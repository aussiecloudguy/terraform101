variable "region" {
  description = "The AWS Region that the resources will be provisioned into"
  default = "ap-southeast-2"
}

variable "ec2_instance_nametag" {
  description = "Value for the Name tag on the server instance which will display on AWS Console. This does not set the Windows Hostname inside the OS"
  default = "terraform-example"
}

variable "aws_profile" {
  description = "AWS Profile to use where multiple credentials exist in a credential file"
  default = "default"  
}

variable "ssh_ingress_cidr" {
  type = list(string)
  description = "The CIDR Block(s) allowed to connect to the machine via SSH. Default is open to all IPs and should be changed"
  default = ["0.0.0.0/0"]   
}

variable "ssh_ingress_port" {
  description = "Port that is open for RDP Ingress. Default is (3389)"
  default = 3389
  
}

# Input variable: Key Pair
variable "keypair_name" {
  description = "The Kaypair Name for Logging in to the Instance after creation. Default is no keypair."
  default = ""
}



# Input variable: VPC ID
variable "vpc_id" {
  description = "The VPC Resources are provisioned into"

}

# Input variable: Subnet ID
variable "subnet_id" {
  description = "The Subnet ID resources are provisioned into"

}
variable "ec2_instance_type" {
  description = "The Instance Type for the New Instance"
  default = "t2.micro"

}

