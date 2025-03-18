# creation of the vpc itself
resource "aws_vpc" "main" {
  cidr_block         = var.vpc_cidr
  enable_dns_support = true
  tags = {
    Name  = "mainVPC-tomer&guy"
    Owner = var.owner
  }
}
# creation public subnet in az1
resource "aws_subnet" "public_subnets" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.main.id
  availability_zone = var.availability_zones[count.index]
  cidr_block        = "10.0.${count.index}.0/24"

  map_public_ip_on_launch = true
  tags = {
    Name  = "public-subnet-${count.index}"
    Owner = var.owner
  }
}
# creation private subnet in  az1
resource "aws_subnet" "private" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.main.id
  availability_zone = var.availability_zones[count.index]
  cidr_block        = "10.1.${count.index}.0/24"
  tags = {
    Name  = "private-subnet-${count.index}"
    Owner = var.owner
  }

}

# IGW
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name  = "mainGW"
    Owner = var.owner
  }
}
# elastic ip for the nat in az1
resource "aws_eip" "nat_azs" {
  count  = length(var.availability_zones)
  domain = "vpc"
}
# attaching nat gw to the public subnet
resource "aws_nat_gateway" "nat_azs" {
  count         = length(var.availability_zones)
  allocation_id = aws_eip.nat_azs[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  tags = {
    Name  = "nat-gateway-${count.index}"
    Owner = var.owner
  }
}

# modifing the route table for the public subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name  = "publicRT"
    Owner = var.owner
  }
}


# modifing the route table for the private subnet
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_azs.id
  }
  tags = {
    Name = "PrivateRouteTable"
  }
}


# attaching RT to the public subnets
resource "aws_route_table_association" "public_subnets" {
  count          = Length(aws_subnets.public_subnets)
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_subnets[count.index].id

}

# attaching RT to the private subnet
resource "aws_route_table_association" "private" {
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private.id
}
