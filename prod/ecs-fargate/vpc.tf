####################### VPC #######################
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags = var.common_tags
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = var.common_tags
}

####################### Private subnets #######################
resource "aws_subnet" "private_subnets" {
  count                   = length(var.private_subnet_cidrs)
  map_public_ip_on_launch = false
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.private_subnet_cidrs, count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index % length(data.aws_availability_zones.available.names))

  tags = merge(
    var.common_tags,
    {
      Name                     = "private-subnet-${count.index}"
      "kubernetes.io/role/elb" = 1
    }
  )
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = var.common_tags
}


resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.private_subnets[0].id

  tags = var.common_tags
}


resource "aws_route_table" "private_rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "private-rtb"
  }
}

resource "aws_route_table_association" "private_rta" {
  count = length(aws_subnet.private_subnets)

  subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = aws_route_table.private_rtb.id
}


####################### Public subnets #######################
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs)
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index % length(data.aws_availability_zones.available.names))

  tags = merge(
    var.common_tags,
    {
      Name                     = "public-subnet-${count.index}"
      "kubernetes.io/role/elb" = 1
    }
  )
}

resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rtb"
  }
}


resource "aws_route_table_association" "public_rta" {
  count = length(aws_subnet.public_subnets)

  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.public_rtb.id
}

####################### Security group #######################
resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
