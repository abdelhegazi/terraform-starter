#/* hegz_vpc */#
resource "aws_vpc" "hegz_vpc" {
  cidr_block           = "${var.mod_vpc_cidr_block}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name           = "hegz_vpc"
    ansible_filter = "hegz_vpc"
  }
}
