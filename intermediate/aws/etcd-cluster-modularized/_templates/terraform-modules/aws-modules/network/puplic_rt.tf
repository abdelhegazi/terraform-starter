// Public Routing Table
resource "aws_route_table" "hegz_vpc_pubrt" {
  vpc_id = "${var.mod_vpc_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.hegz_igw.id}"
  }

  tags {
    Name           = "hegz_vpc_pubrt"
    ansible_filter = "hegz_vpc_pubrt"
  }
}

// Begin Public Subnet Creation
// public subnet
resource "aws_subnet" "hegz_pubsn" {
  count             = "${var.mod_pubsn_count}"
  vpc_id            = "${var.mod_vpc_id}"
  cidr_block        = "${element(split(",", var.mod_hegz_public_cidr_block), count.index)}"
  availability_zone = "${element(split(",", var.mod_azs), count.index)}"

  tags {
    Name           = "hegz_pubsn_etcd_${element(split(",", var.mod_azs), count.index)}"
    ansible_filter = "hegz_pubsn_etcd_${element(split(",", var.mod_azs), count.index)}"
  }
}

##/* Public subnets association with the RT */#
resource "aws_route_table_association" "hegz_pubsn_routing" {
  count          = "${var.mod_pubsn_count}"
  subnet_id      = "${element(aws_subnet.hegz_pubsn.*.id, count.index)}"
  route_table_id = "${aws_route_table.hegz_vpc_pubrt.id}"
}
