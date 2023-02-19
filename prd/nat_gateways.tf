resource "aws_nat_gateway" "mastodon-public-nat-gateway" {
  allocation_id = aws_eip.mastodon-public-eip.id
  subnet_id     = aws_subnet.public-mastodon.id

  tags = {
    "Name" = "mastodon-public-nat-gateway"
  }
}
