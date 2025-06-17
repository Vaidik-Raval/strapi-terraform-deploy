variable "region" {
  default = "us-east-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  description = "SSH key name"
  type        = string
  default     = "strapinew"
}

variable "docker_image" {
  default = "vaidikraval5/strapi-app"
}
