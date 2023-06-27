# AWS Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs

# Steps:
# 0. Select a provider                                                          https://registry.terraform.io/providers/hashicorp/aws/latest
# 1. Create an EC2 instance                                                     https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
# 2. Create Elastic IP and assign                                               https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
# 3. Create a security group to open ports                                      https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
# optional. Define output to display after apply                                https://developer.hashicorp.com/terraform/language/values/outputs

terraform {
  # All providers: https://registry.terraform.io/browse/providers?product_intent=terraform
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

# 0. Select a provider 
provider "aws" {
  region = "us-east-1"
}

# 1. Create a new EC2 instance

resource "aws_instance" "my_instance" {
  ami           = "ami-053b0d53c279acc90" # AMI ID for Ubuntu 20.04 LTS (free tier) # Find an AMI: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/finding-an-ami.html
  instance_type = "t2.micro"
  #   key_name      = aws_key_pair.my_key_pair.key_name
  key_name               = "iic2173"
  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  # user_data is used to run an script after provisioning the instance
  # user_data = "${file("./scripts/deployment.sh")}"
  tags = {
    Name = "ayudantia-iac"
  }
}

# 2. Create and assign Elastic IP
resource "aws_eip" "my_eip" {
  instance = aws_instance.my_instance.id
}

# 3. Create a security group to open ports
resource "aws_security_group" "my_security_group" {
  name        = "my-security-group"
  description = "Security group for SSH access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# Output to dislay after `terraform apply`
output "elastic_ip" {
  value = aws_eip.my_eip.public_ip
}

output "ssh_command" {
  value = "ssh -i ${aws_instance.my_instance.key_name}.pem ubuntu@${aws_eip.my_eip.public_ip}"
}
