





# -----------------------------
# IAM ROLES
# -----------------------------
data "aws_iam_role" "codedeploy_role" {
  name = "CodeDeployRole"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "codedeploy_role_attach" {
  role       = data.aws_iam_role.codedeploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRoleForECS"
}

# -----------------------------
# CODEDEPLOY APP & GROUP
# -----------------------------
resource "aws_codedeploy_app" "strapi_app" {
  name              = var.app_name
  compute_platform  = "ECS"
}

resource "aws_codedeploy_deployment_group" "strapi_group" {
  app_name               = aws_codedeploy_app.strapi_app.name
  deployment_group_name  = var.deployment_group_name
  service_role_arn       = data.aws_iam_role.codedeploy_role.arn

  deployment_style {
    deployment_type = "BLUE_GREEN"
    deployment_option = "WITH_TRAFFIC_CONTROL"
  }

  blue_green_deployment_config {
    terminate_blue_instances_on_deployment_success {
      action = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
      wait_time_in_minutes = 0
    }
  }

  ecs_service {
    cluster_name = var.cluster_name
    service_name = var.service_name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.alb_listener_arn]
      }

      target_group {
        name = var.target_group_blue_arn
      }
      target_group {
        name = var.target_group_green_arn
      }
    }
  }
}

# -----------------------------
# APP SPEC (TEMPLATE)
# -----------------------------
data "template_file" "appspec" {
  template = file("./appspec.tpl.yaml")

  vars = {
    task_def_arn   = aws_ecs_task_definition.strapi.arn
    container_name = "strapi"
    container_port = 1337
  }
}

resource "aws_s3_bucket" "appspec_bucket" {
  bucket = "strapi-appspec-bucket"
  force_destroy = true
}

resource "aws_s3_object" "appspec_yaml" {
  bucket = aws_s3_bucket.appspec_bucket.id
  key    = "appspec.yaml"
  content = data.template_file.appspec.rendered
}

# -----------------------------
# DEPLOYMENT TRIGGER
# -----------------------------
resource "aws_codedeploy_deployment" "trigger" {
  app_name               = aws_codedeploy_app.strapi_app.name
  deployment_group_name = aws_codedeploy_deployment_group.strapi_group.deployment_group_name

  revision {
    revision_type = "S3"

    s3_location {
      bucket     = aws_s3_bucket.appspec_bucket.id
      key        = aws_s3_object.appspec_yaml.key
      bundle_type = "YAML"
    }
  }
}

# -----------------------------
# ECS TASK (example only — define it properly above this)
# -----------------------------
resource "aws_ecs_task_definition" "strapi" {
  family                   = var.app_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = data.aws_iam_role.ecs_task_exec.arn
  container_definitions    = jsonencode([{
    name      = "strapi",
    image     = "${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.ecr_repo}:latest",
    portMappings = [{
      containerPort = 1337,
      protocol = "tcp"
    }]
  }])
}

data "aws_iam_role" "ecs_task_exec" {
  name = "ecsTaskExecutionRole"
}

resource "aws_iam_role_policy_attachment" "ecs_exec_attach" {
  role       = data.aws_iam_role.ecs_task_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
