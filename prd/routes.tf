resource "aws_route_table" "internet-to-public-route-table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-internet-gateway.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public-route-table-association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.internet-to-public-route-table.id
}

# resource "aws_route_table" "public-to-private-route-table" {
#   vpc_id = aws_vpc.main.id
#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.public-nat-gateway.id
#   }

#   tags = {
#     Name = "private-route-table"
#   }
# }

# resource "aws_route_table_association" "private-route-table-association" {
#   subnet_id      = aws_subnet.private.id
#   route_table_id = aws_route_table.public-to-private-route-table.id
# }
