#resource "aws_nat_gateway" "nat_gateway" {
#  allocation_id = aws_eip.nat_gateway.id
#  subnet_id     = aws_subnet.nat_gateway_subnet.id
#  tags = {
#    "Name" = "DummyNatGateway"
#  }
#}
