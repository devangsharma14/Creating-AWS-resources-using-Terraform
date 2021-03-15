resource "aws_subnet" "public1" {
  vpc_id     = "${aws_vpc.my_app.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "demo-public-subnet-1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id     = "${aws_vpc.my_app.id}"
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "demo-public-subnet-2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.my_app.id}"

  tags = {
    Name = "AvisIgw"
  }
}

resource "aws_route_table" "prt" {
  vpc_id = "${aws_vpc.my_app.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags = {
    Name = "AvisPRT"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = "${aws_subnet.public1.id}"
  route_table_id = "${aws_route_table.prt.id}"
}

resource "aws_route_table_association" "b" {
  subnet_id      = "${aws_subnet.public2.id}"
  route_table_id = "${aws_route_table.prt.id}"
}