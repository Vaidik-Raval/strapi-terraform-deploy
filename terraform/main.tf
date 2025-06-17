provider "aws" {
  region = var.region
}

resource "aws_instance" "strapi" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2 AMI (x86_64)
  instance_type = var.instance_type
  key_name      = var.key_name

  user_data = templatefile("${path.module}/user-data.sh", {
    docker_image = var.docker_image
  })

  tags = {
    Name = "StrapiEC2"
  }
}
