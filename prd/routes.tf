resource "aws_route_table" "internet-to-public-mastodon-route-table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-internet-gateway.id
  }

  tags = {
    Name = "internet-to-public-mastodon-route-table"
  }
}

resource "aws_route_table_association" "public-mastodon-route-table-association" {
  subnet_id      = aws_subnet.public-mastodon.id
  route_table_id = aws_route_table.internet-to-public-mastodon-route-table.id
}

resource "aws_route_table" "public-mastodon-to-private-mastodon-route-table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.mastodon-public-nat-gateway.id
  }

  tags = {
    Name = "public-mastodon-to-private-mastodon-route-table"
  }
}

resource "aws_route_table_association" "private-mastodon-route-table-association" {
  subnet_id      = aws_subnet.private-mastodon.id
  route_table_id = aws_route_table.public-mastodon-to-private-mastodon-route-table.id
}
