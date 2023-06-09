
# Create a new EC2 instance
resource "aws_instance" "my_instance" {
  ami           = "ami-053b0d53c279acc90" # AMI ID for Ubuntu 20.04 LTS (free tier)
  instance_type = "t2.micro"
  #   key_name      = aws_key_pair.my_key_pair.key_name
  key_name               = "ayudantia-iaac-terraform"
  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  tags      = var.tags
  user_data = file("${path.module}/install_nginx.sh")

}

resource "aws_eip" "my_eip" {
  instance = aws_instance.my_instance.id
}

resource "aws_eip_association" "my_eip_association" {
  instance_id   = aws_instance.my_instance.id
  allocation_id = aws_eip.my_eip.id
}

# Create a security group
resource "aws_security_group" "my_security_group" {
  name        = "my-security-group"
  description = "Security group for SSH access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "elastic_ip" {
  value = aws_eip.my_eip.public_ip
}
