variable "region" {
  description = "The AWS Region that the resources will be provisioned into"
  default = "ap-southeast-2"
}


variable "aws_profile" {
  description = "AWS Profile to use where multiple credentials exist in a credential file"
  default = "default"  
}
