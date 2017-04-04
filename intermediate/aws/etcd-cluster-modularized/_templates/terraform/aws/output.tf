// OpenVPN Public IP
data "template_file" "openvpn_info_public_ip" {
    template	 = "openvpn_server_public_ip : $${public_ip} "

    vars {
	public_ip = "${module.ovpn.hegz_openvpn_public_ip}"
    }
}

// OpenVPN private IPs
data "template_file" "openvpn_info_private_ip" {
    template	= "openvpn_server_private_ip: $${private_ip}"

    vars {
	private_ip = "${module.ovpn.hegz_openvpn_private_ip}"
    }
}

// etcd private IPs
data "template_file" "tecd_info_private_ip" {
    template	= "etcd private Ips: \n $${private_ips}"

    vars {
	private_ips = "${module.compute-infra.etcd_instances_private_ips}"
    }
}


output "hegz_openvpn_public_ip" {
//    value = "${module.ovpn.hegz_openvpn_public_ip}"

    value = "$data.template_file.openvpn_info_public_ip.rendered"
}


output "hegz_openvpn_private_ip" {
    value = "${plit (",", module.ovpn.hegz_openvpn_private_ip)}"
}


output "etcd_instances_private_ips" {
    value = ["${module.compute-infra.etcd_instances_private_ips}"]
}




#output "hegz_openvpn_security_groups" {
#    value = "${module.ovpn.hegz_openvpn_security_groups}"
#}




