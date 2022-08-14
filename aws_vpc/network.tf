#creating vpc
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/26"
  instance_tenancy = "default"

  tags = {
    Name = "pet-project-vpn-vpc"
  }
}

#creating a public subnet
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/27"
  map_public_ip_on_launch = true
  availability_zone = "me-south-1a"

  tags = {
    Name = "pet-project-vpn-public-subnet"
  }
}


#creating a private subnet
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.32/27"
  map_public_ip_on_launch = false
  availability_zone = "me-south-1a"

  tags = {
    Name = "pet-project-vpn-private-subnet"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "pet-project-vpn-igw"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.main.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}
