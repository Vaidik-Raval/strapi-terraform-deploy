provider "aws" {
  region = "eu-north-1"
}

variable "dev_public_key" {
  description = "Public key for EC2 access"
  type        = string
}

variable "dev_private_key" {
  description = "Private key for SSH access"
  type        = string
}

resource "aws_key_pair" "dev_key" {
  key_name   = "dev-key"
  public_key = var.dev_public_key
}

resource "aws_security_group" "strapi_sg" {
  name        = "strapi-sg-New"
  description = "Allow SSH and Strapi ports"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

  tags = {
    Name = "StrapiSecurityGroup"
  }
}

resource "aws_instance" "strapi_ec2" {
  ami                         = "ami-05fcfb9614772f051"
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.dev_key.key_name
  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.strapi_sg.id]

  user_data = file("${path.module}/user-data.sh")

  tags = {
    Name = "StrapiAppServer"
  }
}
