resource "aws_route_table" "public-mastodon-route-table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-internet-gateway.id
  }

  tags = {
    Name = "public-mastodon-route-table"
  }
}

resource "aws_route_table_association" "public-mastodon-route-table-association" {
  subnet_id      = aws_subnet.public-mastodon.id
  route_table_id = aws_route_table.public-mastodon-route-table.id
}

resource "aws_route_table" "private-mastodon-route-table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = aws_network_interface.nat-instance-eni.id
  }

  tags = {
    Name = "private-mastodon-route-table"
  }
}

resource "aws_route_table_association" "private-mastodon-route-table-association" {
  subnet_id      = aws_subnet.private-mastodon.id
  route_table_id = aws_route_table.private-mastodon-route-table.id
}

