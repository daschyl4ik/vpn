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