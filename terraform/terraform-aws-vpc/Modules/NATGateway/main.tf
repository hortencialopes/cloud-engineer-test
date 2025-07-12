resource "aws_eip" "eip_for_nat_gateway_az1" {
  domain = "vpc"

  tags = {
    Name = "Nat Gateway AZ1 EIP"
  }
}

resource "aws_eip" "eip_for_nat_gateway_az2" {
  domain = "vpc"

  tags = {
    Name = "Nat Gateway AZ2 EIP"
  }
}

resource "aws_nat_gateway" "nat_gateway_az1" {
  allocation_id = aws_eip.eip_for_nat_gateway_az1.id
  subnet_id     = var.public_subnet_az1_id

  tags = {
    Name = "Nat Gateway AZ1"
  }

  depends_on = [var.internet_gateway]
}

resource "aws_nat_gateway" "nat_gateway_az2" {
  allocation_id = aws_eip.eip_for_nat_gateway_az2.id
  subnet_id     = var.public_subnet_az2_id

  tags = {
    Name = "Nat Gateway AZ2"
  }

  depends_on = [var.internet_gateway]
}

resource "aws_route_table" "private_route_table_az1" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_az1.id
  }

  tags = {
    Name = "Private Route Table AZ1"
  }
}

resource "aws_route_table_association" "private_subnet_az1_route_table_az1_association" {
  subnet_id      = var.private_subnet_az1_id
  route_table_id = aws_route_table.private_route_table_az1.id
}

resource "aws_route_table" "private_route_table_az2" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_az2.id
  }

  tags = {
    Name = "Private Route Table AZ2"
  }
}

resource "aws_route_table_association" "private_subnet_az2_route_table_az2_association" {
  subnet_id      = var.private_subnet_az2_id
  route_table_id = aws_route_table.private_route_table_az2.id
}