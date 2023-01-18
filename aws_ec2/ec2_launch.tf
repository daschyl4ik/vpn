# find the VPC that matches the tags and gather all its data.
data "aws_subnet" "public" {
  tags = {
    Name = "pet-project-vpn-public-subnet"
  }
}


#creating security group
resource "aws_security_group" "main" {
  name        = "pet-project-vpn-sg"
  description = "Allow my IP range"
  vpc_id = var.vpc_id

  ingress {
    description      = "OpenVPN from my device - TCP"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [var.my-beeline-subnet-cidr, var.my-tele2-subnet-cidr, var.my-converge-subnet-cidr]
  }

ingress {
    description      = "OpenVPN from my device - UDP"
    from_port        = 1194
    to_port          = 1194
    protocol         = "udp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

ingress {
    description      = "To access the instance"
    from_port        = 22
    to_port          = 22
    protocol         = "TCP"
    cidr_blocks      = [var.my-beeline-subnet-cidr, var.my-tele2-subnet-cidr, var.my-converge-subnet-cidr]
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


#launch instance
resource "aws_instance" "main" {
  ami           = "ami-0c9b2924fcd9b73a4"     #free tier eligible, Ubuntu, 22.04 LTS, amd64
  instance_type = "t3.micro"                  #free tier eligible
  subnet_id = data.aws_subnet.public.id

  credit_specification {
    cpu_credits = "standard"
  }

root_block_device {
  volume_type = "gp3"
  volume_size = 8
  iops = 3000
}

tags = {
  Name = "pet-project-vpn-ec2"
}

user_data = templatefile("userdata.sh.tftpl", {
  user = "vpn_admin",
  public_key = var.public_key
})

vpc_security_group_ids = [aws_security_group.main.id]
#vpc_security_group_ids = ["sg-0e8917fac11bfc148"]

}