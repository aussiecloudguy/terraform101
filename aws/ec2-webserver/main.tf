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
  profile = "prod"
}

provider "aws" {
  assume_role {
    role_arn     = "arn:aws:iam::123456789012:role/ROLE_NAME"
    session_name = "SESSION_NAME"
    external_id  = "EXTERNAL_ID"
  }
}
# Create a Security Group for an EC2 instance
resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
  vpc_id = "${var.vpc_id}"  
  ingress {
    from_port	  = "${var.server_port}"
    to_port	    = "${var.server_port}"
    protocol	  = "tcp"
    security_groups = 
    
  }

  egress {
    from_port = 0
    to_port = 0
    protocol	  = -1
    cidr_blocks	= ["0.0.0.0/0"]
  }
}

# Create a Security Group for an EC2 instance
resource "aws_security_group" "lb_sg" {
  name = "terraform-example-loadbalancer"
  vpc_id = "${var.vpc_id}"  
  ingress {
    from_port	  = "${var.server_port}"
    to_port	    = "${var.server_port}"
    protocol	  = "tcp"
    cidr_blocks	= ["0.0.0.0/0"]
  }

  
}

# Get the Latest Amazon Linux AMI

data "aws_ami" "base_ami" {
  most_recent      = true
  owners           = ["amazon"]
 
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
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

resource "aws_instance" "web" {
  ami           = data.aws_ami.base_ami.image_id
  instance_type = "t3.micro"

  tags = {
    Name = "HelloWorld"
  }
}

# Create an EC2 instance
resource "aws_instance" "example" {
  ami                     = data.aws_ami.base_ami.image_id 
  instance_type           = "${var.ec2_instance_type}"
  vpc_security_group_ids  = ["${aws_security_group.instance.id}"]
  subnet_id = "${var.subnet_id}"
  key_name = "${var.keypair_name}"
  
  user_data = <<-EOF
	      #!/bin/bash
          echo "Hello, World" > index.html
          dnf upgrade -y
          dnf install -y httpd
          systemctl start httpd.service
          systemctl enable httpd.service
          EOF
			  
  tags = {
    Name = "terraform-example"
  }
}

resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]

# Output variables
output "securitygroup_ip" {
  value = "${aws_security_group.instance.id}"
}
output "instance_ip" {
  value = "${aws_instance.example.id}"
}
output "public_ip" {
  value = "${aws_instance.example.public_ip}"
}