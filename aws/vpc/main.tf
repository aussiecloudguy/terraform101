terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.86.1"
    }
  }
}

# Configure the AWS provider
provider "aws" {
  region = "${var.region}" # region = "ap-southeast-2"
  profile = "${var.aws_profile}"
}


locals {
  public_subnets = {
    "${var.region}a" = "${var.public_subnet_CIDR_a}"
    "${var.region}b" = "${var.public_subnet_CIDR_b}"
    "${var.region}c" = "${var.public_subnet_CIDR_c}"
  }
  private_subnets = {
    "${var.region}a" = "${var.private_subnet_CIDR_a}"
    "${var.region}b" = "${var.private_subnet_CIDR_b}"
    "${var.region}c" = "${var.private_subnet_CIDR_c}"
  }
}

resource "aws_vpc" "example" {
  cidr_block = "${var.vpc_CIDR}"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.vpc_name}-vpc"
  }
}

resource "aws_internet_gateway" "vpc_ig" {
  vpc_id = "${aws_vpc.example.id}"

  tags = {
    Name = "${var.vpc_name}-internet-gateway"
  }
}

resource "aws_subnet" "public" {
  count      = "${length(local.public_subnets)}"
  cidr_block = "${element(values(local.public_subnets), count.index)}"
  vpc_id     = "${aws_vpc.example.id}"

  map_public_ip_on_launch = true
  availability_zone       = "${element(keys(local.public_subnets), count.index)}"

  tags = {
    Name = "${element(keys(local.public_subnets), count.index)}-Public-Subnet"
    Tier = "Public"
  }
}

resource "aws_subnet" "private" {
  count      = "${length(local.private_subnets)}"
  cidr_block = "${element(values(local.private_subnets), count.index)}"
  vpc_id     = "${aws_vpc.example.id}"

  map_public_ip_on_launch = true
  availability_zone       = "${element(keys(local.private_subnets), count.index)}"

  tags = {
    Name = "${element(keys(local.public_subnets), count.index)}-Private-Subnet"
    Tier = "Private"
  }
}

resource "aws_default_route_table" "public" {
  default_route_table_id = "${aws_vpc.example.main_route_table_id}"

  tags = {
    Name = "${var.vpc_name}-public"
  }
}

resource "aws_route" "public_internet_gateway" {
  count                  = "${length(local.public_subnets)}"
  route_table_id         = "${aws_default_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.vpc_ig.id}"

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "public" {
  count          = "${length(local.public_subnets)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_default_route_table.public.id}"
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.example.id}"

  tags = {
    Name = "${var.vpc_name}-private"
  }
}

resource "aws_route_table_association" "private" {
  count          = "${length(local.private_subnets)}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
}

resource "aws_eip" "nat" {
  

  tags = {
    Name = "${var.vpc_name}-natgw-eip"
  }
}

resource "aws_nat_gateway" "this" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.public.0.id}"

  tags = {
    Name = "${var.vpc_name}-nat-gw"
  }
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = "${aws_route_table.private.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.this.id}"

  timeouts {
    create = "5m"
  }
}