output "etcd_instances_ids" {
    value = "${split(",", aws_instance.etcd_instances.*.id)}"
}

output "etcd_instances_private_ips" {
    value = "${join(",", aws_instance.etcd_instances.*.private_ip)}"
}

output "etcd_instance_security_groups" {
    value = "${join(",", aws_instance.etcd_instances.*.security_groups)}"
}


output "etcd_sg1" {
    value = "${aws_security_group.etcd_sg1.id}"
}

