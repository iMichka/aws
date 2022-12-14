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
    Name = "subnet-public-1"
  }
}
