resource "aws_internet_gateway" "main-internet-gateway" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-internet-gateway"
  }
}
