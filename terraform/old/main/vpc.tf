resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags {
    Name       = "main"
    created_by = "Terraform"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "10.0.128.0/20"
  availability_zone = "us-west-1a"
  map_public_ip_on_launch = true

  tags {
    Name = "public"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "10.0.0.0/19"
  availability_zone = "us-west-1a"

  tags {
    Name = "private"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "public"
  }
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.gw.id}"
  }

  tags {
    Name = "private"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = "${aws_subnet.private.id}"
  route_table_id = "${aws_route_table.private.id}"
}

resource "aws_route_table_association" "public" {
  subnet_id      = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.public.id}"
}
