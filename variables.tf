variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "ami" {
  description = "Amazon Machine Image ID"
  default     = "ami-0c02fb55956c7d316"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  default     = "my-ec2-from-git"
}

variable "environment" {
  description = "Environment name"
  default     = "dev"
}
