output "etcd_instances_ids" {
    value = "${split(",", aws_instance.openvpn_server.*.id)}"
}

// OpenVPN Public IP
output "hegz_openvpn_public_ip" {
    value = "${aws_instance.openvpn_server.public_ip}"
}

output "hegz_openvpn_private_ip" {
    value = "${aws_instance.openvpn_server.private_ip}"
}

output "hegz_openvpn_security_groups" {
    value = "${aws_instance.openvpn_server.security_groups}"
}


output "openvpn_sg1_id" {
    value = "${aws_security_group.openvpn_sg1.id}"
}

