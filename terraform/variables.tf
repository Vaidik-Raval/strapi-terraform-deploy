variable "project_name" {
  default = "strapi-app"
}

variable "aws_region" { 
  default = "us-east-1" 
}
variable "ecr_repo" { 
  default = "strapi-app" 
}
variable "app_name" { 
  default = "strapi-app" 
}

variable "deployment_group_name" { 
  default = "strapi-deployment-group" 
}
variable "alb_listener_arn" {}
variable "target_group_blue_arn" {}
variable "target_group_green_arn" {}

variable "cluster_name" { 
  default = "strapi-cluster" 
}
variable "service_name" { 
  default = "strapi-service" 
}