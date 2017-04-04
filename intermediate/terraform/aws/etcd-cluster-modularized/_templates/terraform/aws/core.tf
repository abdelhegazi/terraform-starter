module "vpc-infra" {
  source = "../../terraform-modules/aws-modules/vpc-infra/"

  mod_vpc_cidr_block = "${var.tf_vpc_cidr_block}"
}

module "network" {
  source = "../../terraform-modules/aws-modules/network"

  mod_vpc_id                  = "${module.vpc-infra.vpc_id}"
  mod_azs                     = "${var.tf_azs}"
  mod_pubsn_count             = "${var.tf_public_subnets_count}"
  mod_privsn_count            = "${var.tf_private_subnets_count}"
  mod_hegz_public_cidr_block  = "${var.tf_hegz_public_cidr_block}"
  mod_hegz_private_cidr_block = "${var.tf_hegz_private_cidr_block}"
  mod_natgws_count            = "${var.tf_private_subnets_count}"
  mod_elb_sg1_name            = "${var.tf_elb_sg1_name}"
  mod_etcd_sg1_id             = "${module.compute-infra.etcd_sg1}"
  mod_etcd_instances_ids      = "${module.compute-infra.etcd_instances_ids}"
}

module "compute-infra" {
  source = "../../terraform-modules/aws-modules/compute-infra"

  mod_etcd_instances_count = "${var.tf_etcd_instances_count}"
  mod_ami                  = "${var.tf_aws_image_id}"
  mod_instance_type        = "${var.tf_aws_instance_type}"
  mod_azs                  = "${var.tf_azs}"
  mod_key_name             = "${var.tf_aws_etcd_key_name}"
  mod_privsn_ids           = "${module.network.privsn_ids}"
  mod_vpc_id               = "${module.vpc-infra.vpc_id}"
  mod_etcd_sg1_name        = "${var.tf_etcd_sg1_name}"
}

module "ovpn" {
  source = "../../terraform-modules/aws-modules/ovpn"

  mod_openvpn_instances_count = "${var.tf_openvpn_instances_count}"

  #    etcd_instances_id	    = "${module.compute-infra.etcd_instances_ids}"
  mod_ami              = "${var.tf_aws_image_id}"
  mod_instance_type    = "${var.tf_aws_instance_type}"
  mod_openvpn_az       = "${var.tf_openvpn_az}"
  mod_key_name         = "${var.tf_aws_openvpn_key_name}"
  mod_pubsn_ids        = "${module.network.pubsn_ids}"
  mod_vpc_id           = "${module.vpc-infra.vpc_id}"
  mod_openvpn_sg1_name = "${var.tf_openvpn_sg1_name}"
}
