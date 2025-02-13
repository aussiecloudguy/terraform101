variable "region" {
  description = "The AWS Region that the resources will be provisioned into"
  default = "ap-southeast-2"
}

variable "aws_profile" {
  description = "The Credential profile for the account"
  
}

variable "vpc_name" {
  description = "The VPC Name (to be suffixed with -vpc"
  default = "vpc"
}

variable "vpc_CIDR" {
  description = "The VPC CIDR Range for devices (all subnets must be allocated from within)"
  default = "10.0.0.0/16"
}

variable "public_subnet_CIDR_a" {
  description = "The VPC CIDR Range for devices (all subnets must be allocated from within)"
  default = "10.0.0.0/24"
}

variable "public_subnet_CIDR_b" {
  description = "The VPC CIDR Range for devices (all subnets must be allocated from within)"
  default = "10.0.1.0/24"
}

variable "public_subnet_CIDR_c" {
  description = "The VPC CIDR Range for devices (all subnets must be allocated from within)"
  default = "10.0.2.0/24"
}

variable "private_subnet_CIDR_a" {
  description = "The VPC CIDR Range for devices (all subnets must be allocated from within)"
  default = "10.0.3.0/24"
}

variable "private_subnet_CIDR_b" {
  description = "The VPC CIDR Range for devices (all subnets must be allocated from within)"
  default = "10.0.4.0/24"
}

variable "private_subnet_CIDR_c" {
  description = "The VPC CIDR Range for devices (all subnets must be allocated from within)"
  default = "10.0.5.0/24"
}


