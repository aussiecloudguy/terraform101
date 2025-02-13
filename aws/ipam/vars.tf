variable "region" {
  description = "The AWS Region that the resources will be provisioned into"
  default = "ap-southeast-2"
}

variable "ipam_pool_ipv4_cidr" {
  description = "The Supernet CIDR for the IPv4 IPAM Pool"
  default = "172.20.0.0/16"
}

variable "aws_profile" {
  description = "AWS Profile to use where multiple credentials exist in a credential file"
  default = "default"  
}