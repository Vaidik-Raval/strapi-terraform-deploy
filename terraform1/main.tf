provider "aws" {
  region = "us-east-1"

}

# Use default VPC
data "aws_vpc" "default" {
  default = true
}

# Use default subnets in that VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Security Group in default VPC
resource "aws_security_group" "strapi_sg1" {
  name   = "strapi-sg1"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ECS Cluster
resource "aws_ecs_cluster" "strapi_cluster1" {
  name = "strapi-cluster1"
}

# Task Definition
resource "aws_ecs_task_definition" "strapi_task1" {
  family                   = "strapi-task1"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "1024"
  memory                   = "3072"

  container_definitions = jsonencode([
    {
      name      = "strapi"
      image     = "vaidikraval5/strapi-app:latest"
      essential = true
      portMappings = [
        {
          containerPort = 1337
          protocol      = "tcp"
        }
      ]
    }
  ])
}

# ECS Service
resource "aws_ecs_service" "strapi_service1" {
  name            = "strapi-service1"
  cluster         = aws_ecs_cluster.strapi_cluster1.id
  task_definition = aws_ecs_task_definition.strapi_task1.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    assign_public_ip = true
    security_groups  = [aws_security_group.strapi_sg1.id]
  }
}