variable "region" {
  description = "The AWS Region that the resources will be provisioned into"
  default = "ap-southeast-2"
}

# Input variable: server port
variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default = "80"
}

# Input variable: server port
variable "subnet_id" {
  description = "The Subnet to Provision the Instance into"

}

# Input variable: server port
variable "keypair_name" {
  description = "The Kaypair Name for Logging in to the Instance after creation"
  default = ""
}



# Input variable: server port
variable "vpc_id" {
  description = "The VPC Resources are provisioned into"

}

variable "ec2_instance_type" {
  description = "The Instance Type for the New Instance"
  default = "t2.micro"

}

#variable "keypair" {

#    description = "The Key Pair to use for Provisioning"

#}
