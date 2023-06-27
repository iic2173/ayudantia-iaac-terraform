# Select the provider and provide configuration details                         https://registry.terraform.io/providers/hashicorp/aws/latest
provider "aws" {
  region = var.region
#   access_key = "var.AWS_ACCESS_KEY" # If TF_VAR_AWS_ACCESS_KEY not exported, the ~/.aws/credentials file will be used
#   secret_key = "var.AWS_SECRET_ACCESS_KEY" # If TF_VAR_AWS_SECRET_ACCESS_KEY not exported, the ~/.aws/credentials file will be used
}

# Provision the project in "./modules/ec2_instance"
module "ec2_web_server" {
  source = "./modules/ec2_instance"
  region = var.region
  tags = var.tags
  ec2_pem_key = var.ec2_pem_key
  ec2_instance_type = var.ec2_instance_type
}
