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
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/26"
  instance_tenancy = "default"

  tags = {
    Name = "pet-project-vpn-vpc"
  }
}

#creating a public subnet
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/27"
  map_public_ip_on_launch = true
  availability_zone = "eu-north-1a"

  tags = {
    Name = "pet-project-vpn-public-subnet"
  }
}


#creating a private subnet
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.32/27"
  map_public_ip_on_launch = false
  availability_zone = "eu-north-1a"

  tags = {
    Name = "pet-project-vpn-private-subnet"
  }

}

#creating security group
resource "aws_security_group" "main" {
  name        = "pet-project-vpn-sg"
  description = "Allow my IP range to"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "OpenVPN from my device - TCP"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [var.my-beeline-subnet-cidr, var.my-tele2-subnet-cidr]
  }

ingress {
    description      = "OpenVPN from my device - UDP"
    from_port        = 1194
    to_port          = 1194
    protocol         = "udp"
    cidr_blocks      = [var.my-beeline-subnet-cidr, var.my-tele2-subnet-cidr]
  }

ingress {
    description      = "To access the instance"
    from_port        = 22
    to_port          = 22
    protocol         = "ssh"
    cidr_blocks      = [var.my-beeline-subnet-cidr, var.my-tele2-subnet-cidr]
  }
#Security groups are stateful—if you send a request from your instance, 
#the response traffic for that request is allowed to flow in regardless of inbound security group rules.

#any outgoing traffic is allowed
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "pet-project-vpn-sg"
  }
}

