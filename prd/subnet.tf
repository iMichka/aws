resource "aws_subnet" "private-mastodon" {
  cidr_block        = "10.0.3.0/24"
  vpc_id            = aws_vpc.main.id
  availability_zone = "${var.region}a"
  tags = {
    Name = "subnet-private-3"
  }
}

resource "aws_subnet" "public-mastodon" {
  cidr_block        = "10.0.4.0/24"
  availability_zone = "${var.region}a"
  vpc_id            = aws_vpc.main.id
  tags = {
    Name = "subnet-public-4"
  }
}
