variable "region" {
  description = "The AWS Region that the resources will be provisioned into"
  default = "ap-southeast-2"
}

variable "subnet_count" {
  default = 4
}

variable "subnet_netmask" {
  
  default = 25
}

variable "ipam_pool_ipv4_cidr" {
  description = "The Supernet CIDR for the IPv4 IPAM Pool"
  default = "172.20.0.0/16"
}

variable "vpc_name" {
  description = "The VPC Name (to be suffixed with -vpc"
  default = "vpc"
}

variable "vpc_netmask" {
  default = 22
}

variable "vpc_subnet_netmask" {
  default = 25
}

variable "aws_profile" {
  description = "AWS Profile to use where multiple credentials exist in a credential file"
  default = "default"  
}

###The Below Vars will be removed once an improved way of handling the subnet IP allocations with IPAM is written
###
###

variable "public_subnet_CIDR_a" {
  description = "The VPC CIDR Range for devices (all subnets must be allocated from within)"
  default = "172.20.0.0/25"
}

variable "public_subnet_CIDR_b" {
  description = "The VPC CIDR Range for devices (all subnets must be allocated from within)"
  default = "172.20.0.128/25"
}

variable "public_subnet_CIDR_c" {
  description = "The VPC CIDR Range for devices (all subnets must be allocated from within)"
  default = "172.20.1.0/25"
}

variable "private_subnet_CIDR_a" {
  description = "The VPC CIDR Range for devices (all subnets must be allocated from within)"
  default = "172.20.1.128/25"
}

variable "private_subnet_CIDR_b" {
  description = "The VPC CIDR Range for devices (all subnets must be allocated from within)"
  default = "172.20.2.0/25"
}

variable "private_subnet_CIDR_c" {
  description = "The VPC CIDR Range for devices (all subnets must be allocated from within)"
  default = "172.20.2.128/25"
}