resource "aws_security_group" "main-security-group" {
  name   = "main-security-group"
  vpc_id = aws_vpc.main.id

  # Allow http 
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Allow https
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Allow ping
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
  }
  # Allow smtp
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 587
    to_port     = 587
    protocol    = "tcp"
  }
  # All outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

