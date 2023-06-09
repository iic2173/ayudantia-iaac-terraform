variable "tags" {
  description = "Tags to set on the ec2 instance."
  type        = map(string)
  default     = {}
}
