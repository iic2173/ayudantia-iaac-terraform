variable "region" {
  description = "Specify AWS region."
  type        = string
}

variable "tags" {
  description = "Specify tags."
  type        = map(string)
}

variable "ec2_instance_type" {
  description   = "Select EC2 instance type/size."
  type          = string
  default       = "t4g.small"
}

variable "ec2_pem_key" {
  description = "Provide an existing pem key name."
  type        = string
}
