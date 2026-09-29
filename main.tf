terraform {
  required_version = "> 1.5.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

terraform {
  backend "http" {
    address = "https://app.harness.io/gateway/iacm/api/orgs/default/projects/Deepeshtestiacm/workspaces/ec2dev/terraform-backend?accountIdentifier=l7HREAyVTnyfUsfUtPZUow"
    username = "harness"
    password = "pat.l7HREAyVTnyfUsfUtPZUow.6a8ac777966c5442af572926.wxerDDvpciBP8YNO3uVO"
    lock_address = "https://app.harness.io/gateway/iacm/api/orgs/default/projects/Deepeshtestiacm/workspaces/ec2dev/terraform-backend/lock?accountIdentifier=l7HREAyVTnyfUsfUtPZUow"
    lock_method = "POST"
    unlock_address = "https://app.harness.io/gateway/iacm/api/orgs/default/projects/Deepeshtestiacm/workspaces/ec2dev/terraform-backend/lock?accountIdentifier=l7HREAyVTnyfUsfUtPZUow"
    unlock_method = "DELETE"
  }
}

provider "aws" {
  region = var.region
}

# Generate SSH key pair
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Register public key with AWS
resource "aws_key_pair" "ec2_keypair" {
  key_name   = "${var.instance_name}-${var.environment}-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

resource "aws_instance" "web" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = aws_key_pair.ec2_keypair.key_name    # ← added
  tags = {
    Name        = "${var.instance_name}-${var.environment}"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_s3_bucket" "storage" {
  bucket = "${var.instance_name}-${var.environment}-storage"
  tags = {
    Name        = "${var.instance_name}-${var.environment}-storage"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

output "bucket_name" {
  value = aws_s3_bucket.storage.bucket
}

output "public_ip" {
  value = aws_instance.web.public_ip
}

output "instance_id" {
  value = aws_instance.web.id
}

# Private key output — use this for Ansible SSH
output "private_key_pem" {
  value     = tls_private_key.ec2_key.private_key_pem
  sensitive = true
}
