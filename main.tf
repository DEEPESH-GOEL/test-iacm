terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "dg-ec2-instance-harness-repo" {
  source  = "module.app.harness.io/l7HREAyVTnyfUsfUtPZUowN0dbHpRgRDOgg09wZK__gg/dg-ec2-instance-harness-repo/aws"
  version = "v1.0.0"
  instance_name = var.instance_name
  instance_type = var.instance_type
  ami           = var.ami
  environment   = var.environment


}
output "instance_id" { value = module.ec2.instance_id }
output "public_ip"   { value = module.ec2.public_ip }
