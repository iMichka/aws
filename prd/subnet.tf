resource "aws_subnet" "instance_subnet" {
  cidr_block        = "10.0.1.0/24"
  vpc_id            = aws_vpc.test-env.id
  availability_zone = "eu-west-3a"
  tags = {
    Name = "instance_subnet"
  }
}

resource "aws_subnet" "nat_gateway_subnet" {
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-3a"
  vpc_id            = aws_vpc.test-env.id
  tags = {
    Name = "DummySubnetNAT"
  }
}
