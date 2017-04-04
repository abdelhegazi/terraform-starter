// BEGIN Private nating
// EIP for nat gateway aza

resource "aws_eip" "hegz_eip_natgw" {
  count = "${var.mod_natgws_count}"
  vpc   = true

  lifecycle {
    create_before_destroy = true
  }
}

// Availability Zones Nat Gateways Allocated to different EIP 
resource "aws_nat_gateway" "hegz_natgw_azs" {
  count         = "${var.mod_natgws_count}"
  allocation_id = "${element(aws_eip.hegz_eip_natgw.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.hegz_pubsn.*.id, count.index)}"

  #    depends_on         = ["aws_internet_gateway.hegz_igw"]
}

// BEGIN  Private subnet Routing table
// Routing Table

resource "aws_route_table" "hegz_vpc_privrt" {
  vpc_id = "${var.mod_vpc_id}"
  count  = "${var.mod_privsn_count}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.hegz_natgw_azs.*.id, count.index)}"
  }

  tags {
    Name           = "hegz_vpc_privrt${element(split(",", var.mod_azs), count.index)}"
    ansible_filter = "hegz_vpc_privrt${element(split(",", var.mod_azs), count.index)}"
  }
}

//  Begin Private Subnet Creation
// AZs private subnet

resource "aws_subnet" "hegz_privsn" {
  count             = "${var.mod_privsn_count}"
  vpc_id            = "${var.mod_vpc_id}"
  cidr_block        = "${element(split(",", var.mod_hegz_private_cidr_block), count.index)}"
  availability_zone = "${element(split(",", var.mod_azs), count.index)}"

  tags {
    Name           = "hegz_privsn_${element(split(",", var.mod_azs), count.index)}"
    ansible_filter = "hegz_privsn_${element(split(",", var.mod_azs), count.index)}"
  }
}

// AZs Private subnets association with the Private RT 
resource "aws_route_table_association" "hegz_privsn_azs_routing" {
  count          = "${var.mod_privsn_count}"
  subnet_id      = "${element(aws_subnet.hegz_privsn.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.hegz_vpc_privrt.*.id, count.index)}"
}
