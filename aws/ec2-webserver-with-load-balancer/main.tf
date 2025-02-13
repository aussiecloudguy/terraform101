# Configure the AWS provider
provider "aws" {
  region = "${var.region}"
  profile = "${var.aws_profile}"
}

# Create a Security Group for a Load Balancer
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


# Create a Security Group for an EC2 instance
resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
  vpc_id = "${var.vpc_id}"  
  ingress {
    from_port	  = "${var.server_port}"
    to_port	    = "${var.server_port}"
    protocol	  = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
    
  }

  egress {
    from_port = 0
    to_port = 0
    protocol	  = -1
    cidr_blocks	= ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "lb_to_instance" {
  type              = "egress"
  from_port = "${var.server_port}"
  to_port = "${var.server_port}"
  protocol          = "tcp"
  source_security_group_id = "${aws_security_group.instance.id}"
  security_group_id = "${aws_security_group.lb_sg.id}"
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

#data "aws_subnet_ids" "selected" { 
#  vpc_id = var.vpc_id
  
  #This will create Load Balancer points in subnets with a Tag that has Tier:Public Name/Value
#  filter { 
#    name = "tag:Tier" 
#    values = ["*Public*"] 
#  } 

    
#}

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
  
  subnets            = var.lb_subnet_ids
  

}

resource "aws_lb_target_group" "test" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = aws_instance.example.id
  port             = 80
}

resource "aws_lb_listener" "test" {
  load_balancer_arn = aws_lb.test.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}

# Output variables
output "securitygroup_ip" {
  value = "${aws_security_group.instance.id}"
}
output "instance_ip" {
  value = "${aws_instance.example.id}"
}
output "lb_public_dns" {
  value = "${aws_lb.test.dns_name}"
}