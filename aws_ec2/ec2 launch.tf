# find the VPC that matches the tags and gather all its data.
data "aws_subnet" "public" {
  tags = {
    Name = "pet-project-vpn-public-subnet"
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

#security_groups - (Optional, EC2-Classic and default VPC only) 
#A list of security group names to associate with.
security_groups = [ "pet-project-vpn-sg" ]

tags = {
  Name = "pet-project-vpn-ec2"
}

user_data = file("userdata.sh")

}
