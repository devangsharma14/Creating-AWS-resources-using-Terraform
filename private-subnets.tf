resource "aws_subnet" "private1" {
  vpc_id     = "${aws_vpc.my_app.id}"
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "demo-private-subnet-3"
  }
}

resource "aws_subnet" "private2" {
  vpc_id     = "${aws_vpc.my_app.id}"
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "demo-private-subnet-4"
  }
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = "eipalloc-056a0a13970bfb95e"
  subnet_id     = "${aws_subnet.public2.id}"
}

resource "aws_route_table" "privatert" {
  vpc_id = "${aws_vpc.my_app.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.natgw.id}"
  }

  tags = {
    Name = "AvisPrivateRT"
  }
}

resource "aws_route_table_association" "c" {
  subnet_id      = "${aws_subnet.private1.id}"
  route_table_id = "${aws_route_table.privatert.id}"
}

resource "aws_route_table_association" "d" {
  subnet_id      = "${aws_subnet.private2.id}"
  route_table_id = "${aws_route_table.privatert.id}"
}