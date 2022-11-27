output "public_ip" {
  description = "Public IP for the ec2 instance"
  value       = aws_instance.node.public_ip
}

output "private_ip" {
  description = "Private IP for the ec2 instance"
  value       = aws_instance.node.private_ip
}
