resource "aws_subnet" "private" {
  cidr_block        = "10.0.1.0/24"
  vpc_id            = aws_vpc.main.id
  availability_zone = "${var.region}a"
  tags = {
    Name = "subnet-private-1"
  }
}

resource "aws_subnet" "public" {
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.region}a"
  vpc_id            = aws_vpc.main.id
  tags = {
    Name = "subnet-public-2"
  }
}

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

resource "aws_subnet" "private-mastodon-db-a" {
  cidr_block        = "10.0.5.0/24"
  vpc_id            = aws_vpc.main.id
  availability_zone = "${var.region}a"
  tags = {
    Name = "subnet-private-db-5"
  }
}

resource "aws_subnet" "private-mastodon-db-b" {
  cidr_block        = "10.0.6.0/24"
  vpc_id            = aws_vpc.main.id
  availability_zone = "${var.region}b"
  tags = {
    Name = "subnet-private-db-6"
  }
}

