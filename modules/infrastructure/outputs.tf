output "name" {
  description = "The name of the VPC"
  value       = aws_vpc.ckad.arn
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.ckad.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.ckad.cidr_block
}

output "security_group_id" {
  description = "The ID of the Security Group"
  value       = aws_security_group.insecure.id
}

output "subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.public.id
}