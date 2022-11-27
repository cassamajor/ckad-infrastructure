variable "aws_key_pair" {
  description = "AWS Key Pair"
  type        = string
}

variable "aws_subnet_id" {
  description = "AWS Subnet ID"
  type        = string
}

variable "aws_security_groups" {
  description = "AWS Security Groups"
  type        = list(any)
}

variable "cloudinit_config" {
  description = "cloudinit_config to apply to the Control Plane"
  type        = string
}

variable "tags" {
  description = "Tags"
  type        = map(any)
  default     = {}
}