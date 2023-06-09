# AWS Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs

# Steps:
# 0. Select a provider                                                          https://registry.terraform.io/providers/hashicorp/aws/latest
# 1. Create a VPC                                                               https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
# 2. Create an Internet Gateway and attach it to the VPC                        https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
# 3. Create a Custom route table
# 4. Create a subnet
# 5. Associate subnet with route table -> Route table association               https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
# 6. Create a security group to open ports                                      https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
# 7. Create a network interface with an IP in the subnet                        https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface
# 8. Create Elastic IP and assign to network interface                          https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
# 9. Create an EC2 instance with the network interface and security group       https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
# optional. Define output to display after apply                                https://developer.hashicorp.com/terraform/language/values/outputs


# 0. Select a provider 
provider "aws" {
  region    = "us-east-1"
}

# 1. Create a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# 2. Create an Internet Gateway and attach it to the VPC
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

# 3. Create a Custom route table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

# 4. Create a subnet
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"
}

# 5. Associate subnet with route table
resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

# 6. Create a security group to open ports
resource "aws_security_group" "main" {
  name        = "open_22_80_443"
  description = "Open SSH, HTTP and HTTPS ports"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "HTTP access"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTPS access"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# 7. Create a network interface with an IP in the subnet
resource "aws_network_interface" "main" {
  subnet_id       = aws_subnet.main.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.main.id]
}

# 8. Create Elastic IP and assign to network interface
resource "aws_eip" "main" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.main.id
  associate_with_private_ip = "10.0.1.50"
  depends_on = [ aws_internet_gateway.main ]
}

# 9. Create an EC2 instance with the network interface and security group
resource "aws_instance" "main" {
  ami           = "ami-0a0c8eebcdd6dcbd0" # Ubuntu Server 22.04 LTS (64-bit (Arm))
  instance_type = "t4g.small"
  availability_zone = "us-east-1b"
  key_name = "iic2173"

  user_data = "${file("./scripts/deployment.sh")}"

  network_interface {
    network_interface_id = aws_network_interface.main.id
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "standard"
  }
}

# Output to dislay after `terraform apply`
output "elastic_ip" {
  value = aws_eip.main.public_ip
}

output "ssh_command" {
  value = "ssh -i ${aws_instance.main.key_name}.pem ubuntu@${aws_eip.main.public_ip}"
}
