resource "aws_security_group" "insecure" {
  name        = "completely_open"
  description = "Allow All Traffic"
  vpc_id      = aws_vpc.ckad.id

  ingress {
    description      = "Allow all ingress"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    description      = "Allow all egress"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "insecure-security-group"
  }
}