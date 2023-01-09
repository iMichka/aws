resource "aws_internet_gateway" "nat_gateway" {
  vpc_id = aws_vpc.test-env.id
  tags = {
    "Name" = "DummyGateway"
  }
}
