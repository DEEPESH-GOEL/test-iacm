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

resource "aws_instance" "web" {
  ami           = var.ami
  instance_type = var.instance_type

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
