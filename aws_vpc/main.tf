terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  required_version = ">= 0.14"
}

provider "aws" {
    access_key = var.AWS_ACCESS_KEY
    secret_key = var.AWS_SECRET_KEY
    region = var.AWS_REGION
}


#creating vpc
resource "aws_vpc" "my_vpc" {
  cidr_block       = "10.0.0.0/26"
  instance_tenancy = "default"

  tags = {
    Name = "my_vpc"
  }
}

#creating a public subnet
resource "aws_subnet" "my_vpc_public" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.0.0/27"
  map_public_ip_on_launch = true
  availability_zone = "eu-north-1a"

  tags = {
    Name = "my_vpc_public"
  }
}


#creating a private subnet
resource "aws_subnet" "my_vpc_private" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.0.32/27"
  map_public_ip_on_launch = false
  availability_zone = "eu-north-1a"

  tags = {
    Name = "my_vpc_private"
  }
}


