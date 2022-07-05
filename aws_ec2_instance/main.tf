provider "aws" {
    access_key = var.AWS_ACCESS_KEY
    secret_key = var.AWS_SECRET_KEY
    region = var.AWS_REGION
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  required_version = ">= 0.14"
}


#launch instance
resource "aws_instance" "my_instance" {
  ami           = "ami-065deacbcaac64cf2"     #free tier eligible, Ubuntu, 22.04 LTS, amd64
  instance_type = "t2.micro"                  #free tier eligible 
  #subnet_id = "available after VPC is created"
}