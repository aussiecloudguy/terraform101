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
  profile = "${var.aws_profile}"
  region = "ap-southeast-2"
}

data "aws_region" "current" {}

resource "aws_vpc_ipam" "example" {
  description = "example"
  operating_regions {
    region_name = data.aws_region.current.name
  }

  tags = {
    Test = "example"
  }
}

resource "aws_vpc_ipam_pool" "example" {
  address_family = "ipv4"
  description = "IPv4 IPAM Pool"
  ipam_scope_id  = aws_vpc_ipam.example.private_default_scope_id
  locale         = data.aws_region.current.name
}

resource "aws_vpc_ipam_pool_cidr" "example" {
  ipam_pool_id = aws_vpc_ipam_pool.example.id
  cidr         = "${var.ipam_pool_ipv4_cidr}"
}