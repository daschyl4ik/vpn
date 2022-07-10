resource "aws_security_group" "main" {
  name        = "pet-project-vpn-sg"
  description = "Allow my IP range"
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