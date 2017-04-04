data "template_file" "init" {
  template = "./init.tpl"

  vars {
    mod_ovpn_pub_addr  = "${module.ovpn.hegz_openvpn_public_ip}"
    mod_ovpn_priv_addr = "${module.ovpn.hegz_openvpn_private_ip}"
  }
}
