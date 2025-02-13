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

# Create a Security Group for an EC2 instance
resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
  vpc_id = "${var.vpc_id}"  
  ingress {
    from_port	  = "${var.rdp_ingress_port}"
    to_port	    = "${var.rdp_ingress_port}"
    protocol	  = "tcp"
    cidr_blocks = "${var.rdp_ingress_cidr}"
    
  }

  egress {
    from_port = 0
    to_port = 0
    protocol	  = -1
    cidr_blocks	= ["0.0.0.0/0"]
  }
}


# Get the Latest Windows AMI

data "aws_ami" "base_ami" {
  most_recent      = true
  owners           = ["amazon"]
 
  filter {
    name   = "name"
    values = ["Windows_Server-${var.windows_server_version}-English-Full-Base-*"]
  }
 
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
 
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
 
}


# Create an EC2 instance
resource "aws_instance" "example" {
  ami                     = data.aws_ami.base_ami.image_id 
  instance_type           = "${var.ec2_instance_type}"

  vpc_security_group_ids  = ["${aws_security_group.instance.id}"]
  subnet_id = "${var.subnet_id}"
  key_name = "${var.keypair_name}"
  
  		  
  tags = {
    Name = "${var.ec2_instance_nametag}"
  }
}


# Output variables
output "securitygroup_id" {
  value = "${aws_security_group.instance.id}"
}
output "instance_id" {
  value = "${aws_instance.example.id}"
}
output "public_ip" {
  value = "${aws_instance.example.public_ip}"
}