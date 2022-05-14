resource "aws_vpc" "cluster-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "cluster-subnet" {
  cidr_block = "10.0.80.0/20"
  vpc_id     = aws_vpc.cluster-vpc.id
}

resource "aws_security_group" "cluster-sg" {
  name   = "cluster-sg"
  vpc_id = aws_vpc.cluster-vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_internet_gateway" "internet-gw" {
  vpc_id = aws_vpc.cluster-vpc.id
}

resource "aws_route_table" "route-table" {
  vpc_id = aws_vpc.cluster-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gw.id
  }
}

resource "aws_route_table_association" "subnet-association" {
  provider = aws

  subnet_id      = aws_subnet.cluster-subnet.id
  route_table_id = aws_route_table.route-table.id
}