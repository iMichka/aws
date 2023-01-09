resource "aws_route_table" "nat_gateway" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nat_gateway.id
  }
}

resource "aws_route_table_association" "nat_gateway" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.nat_gateway.id
}

#resource "aws_route_table" "private" {
#  vpc_id = aws_vpc.main.id
#  route {
#    cidr_block     = "0.0.0.0/0"
#    nat_gateway_id = aws_nat_gateway.nat_gateway.id
#  }
#}

#resource "aws_route_table_association" "private" {
#  subnet_id      = aws_subnet.private.id
#  route_table_id = aws_route_table.private.id
#}
