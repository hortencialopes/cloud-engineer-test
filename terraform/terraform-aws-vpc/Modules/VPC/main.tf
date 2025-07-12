/**
Contains the code for my vpc module
References: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
*/

# Creating our vpc

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

#Creating our internet gateway attached already to our vpc
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# This is a way to get all the azs in the region
data "aws_availability_zones" "availability_zones" {}

#creating the publics subnets
resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_az1_cidr
  availability_zone       = data.aws_availability_zones.availability_zones.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet AZ1 - ${self.availability_zone}"
  }
}

resource "aws_subnet" "public_subnet_az2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_az2_cidr
  availability_zone       = data.aws_availability_zones.availability_zones.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet AZ2 - ${self.availability_zone}"
  }
}

# creating the public route table for our vpc - routing to the web
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

#associating our publicsubs routetables
resource "aws_route_table_association" "public_subnet_az1_rt_association" {
  subnet_id      = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.public_route_table.id
}
resource "aws_route_table_association" "public_subnet_az2_rt_association" {
  subnet_id      = aws_subnet.public_subnet_az2.id
  route_table_id = aws_route_table.public_route_table.id
}

#creating our private subnets
resource "aws_subnet" "private_subnet_az1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_subnet_az1_cidr
  availability_zone       = aws_subnet.public_subnet_az1.availability_zone
  map_public_ip_on_launch = false

  tags {
    Name = "Private Subnet AZ1 - ${self.availability_zone}"
  }
}

resource "aws_subnet" "private_subnet_az2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_subnet_az2_cidr
  availability_zone       = aws_subnet.public_subnet_az2.availability_zone
  map_public_ip_on_launch = false

  tags {
    Name = "Private Subnet AZ2 - ${self.availability_zone}"
  }
}
