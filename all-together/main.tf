terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.49.0"
    }
  }

  backend "s3" {
    bucket = "terraform-state-bucket-iic2173"
    key    = "all-together-example.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "public_files_bucket" {
  source      = "./modules/aws-public-read-bucket"
  bucket_name = "all-together-terraform-bucket-iic2173"

  tags = {
    Terraform   = "true"
    Environment = "staging"
  }
}

module "ec2_web_server" {
  source = "./modules/ec2-instance"

  tags = {
    Name        = "ayudantia-iaac-terraform"
    Terraform   = "true"
    Environment = "staging"
  }
}
