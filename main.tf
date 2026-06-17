terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}

provider "aws" { region = var.region }

module "ec2" {
  source = "app.harness.io/l7HREAyVTnyfUsfUtPZUow/default/Deepeshtestiacm/4953/aws"
  version = "1.0.0"

  ami           = var.ami
  instance_type = var.instance_type
  instance_name = var.instance_name
  environment   = var.environment
}

output "instance_id" { value = module.ec2.instance_id }
output "public_ip"   { value = module.ec2.public_ip }
