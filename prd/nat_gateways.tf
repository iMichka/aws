resource "aws_internet_gateway" "nat_gateway" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "DummyGateway"
  }
}
