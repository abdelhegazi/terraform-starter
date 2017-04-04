//IGW

output "igw_id" {
    value = "${aws_internet_gateway.hegz_igw.id}"
}


// public routing table

output "pubrt_id" {
    value = "${aws_route_table.hegz_vpc_pubrt.id}"
}


// Public subnets

output "pubsn_ids" {
    value = "${join(",", aws_subnet.hegz_pubsn.*.id)}"
}


#output "pubsn_routing_ids" {
#    value = "${join(",", aws_route_table_association.hegz_pubsn_routing.*.id)}"
#}


// Private Subnets - nat_gateways - routing


output "natgws_ids" {
    value = "${join (",", aws_nat_gateway.hegz_natgw_azs.*id)}"
}



output "privrt_ids" {
    value = "${join (",", aws_route_table.hegz_vpc_privrt.*.id)}"
}



output "privsn_ids" {
    value = "${join(",", aws_subnet.hegz_privsn.*.id)}"
}


#output "privsn_routing_ids" {
#    value = "${aws_route_table_association.hegz_privsn_azs_routing.*.id}"
#}

output "etcd_elb_id" {
    value = "${aws_elb.hegz_etcd_elb.id}"
}


output "aws_security_group" {
    value = "${aws_security_group.etcd_elb_sg1.id}"
}
