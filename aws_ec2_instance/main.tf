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
resource "aws_instance" "main" {
  ami           = "ami-0440e5026412ff23f"     #free tier eligible, Ubuntu, 22.04 LTS, amd64
  instance_type = "t3.micro"                  #free tier eligible 

  credit_specification {
    cpu_credits = "standard"
  }

root_block_device {
  volume_type = "gp3"
  volume_size = 8
  iops = 3000
}

#security_groups - (Optional, EC2-Classic and default VPC only) 
#A list of security group names to associate with.
security_groups = [ "pet-project-vpn-sg" ]

tags {
  Name = "pet-project-vpn-ec2"
}


}
