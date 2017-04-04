#/* hegz_vpc_igw */
resource "aws_internet_gateway" "hegz_igw" {
  vpc_id = "${var.mod_vpc_id}"

  tags {
    Name           = "hegz_vpc_igw"
    ansible_filter = "hegz_vpc_iwg"
  }
}
