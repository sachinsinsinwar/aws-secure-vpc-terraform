terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}


# -----------------------------
# VPC
# -----------------------------

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = "cloudsec-vpc"
    Project = "aws-secure-vpc-terraform"
  }
}

# -----------------------------
# Public Subnet
# -----------------------------

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"

  tags = {
    Name    = "cloudsec-public-subnet"
    Project = "aws-secure-vpc-terraform"
    Tier    = "public"
  }
}

# -----------------------------
# Private Subnet
# -----------------------------

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.aws_region}a"

  tags = {
    Name    = "cloudsec-private-subnet"
    Project = "aws-secure-vpc-terraform"
    Tier    = "private"
  }
}

# -----------------------------
# Internet Gateway
# -----------------------------

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name    = "cloudsec-igw"
    Project = "aws-secure-vpc-terraform"
  }
}

# -----------------------------
# Public Route Table
# -----------------------------

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name    = "cloudsec-public-rt"
    Project = "aws-secure-vpc-terraform"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

# -----------------------------
# NAT Gateway for Private Subnet
# -----------------------------

# Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  vpc = true

  tags = {
    Name    = "cloudsec-nat-eip"
    Project = "aws-secure-vpc-terraform"
  }
}

# NAT Gateway in the public subnet
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id

  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name    = "cloudsec-nat-gateway"
    Project = "aws-secure-vpc-terraform"
  }
}

# -----------------------------
# Private Route Table (via NAT)
# -----------------------------

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name    = "cloudsec-private-rt"
    Project = "aws-secure-vpc-terraform"
  }
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_rt.id
}
