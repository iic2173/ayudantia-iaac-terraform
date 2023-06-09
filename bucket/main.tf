terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "public_bucket" {
  bucket = "ayudantia-iaac-terraform" # Replace with your desired bucket name
}

resource "aws_s3_bucket_public_access_block" "public_bucket_public_access_block" {
  bucket = aws_s3_bucket.public_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_bucket_policy" {
  bucket     = aws_s3_bucket.public_bucket.id
  depends_on = [aws_s3_bucket_public_access_block.public_bucket_public_access_block]
  policy     = <<EOF
                {
                  "Version": "2012-10-17",
                  "Statement": [
                    {
                      "Sid": "PublicRead",
                      "Effect": "Allow",
                      "Principal": "*",
                      "Action": ["s3:GetObject"],
                      "Resource": ["arn:aws:s3:::${aws_s3_bucket.public_bucket.id}/*"]
                    }
                  ]
                }
            EOF
}

output "bucket_name" {
  value = aws_s3_bucket.public_bucket.bucket
}
