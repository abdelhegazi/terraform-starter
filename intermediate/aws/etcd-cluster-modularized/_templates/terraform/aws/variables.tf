variable "tf_vpc_cidr_block" {
  default = "172.20.0.0/16"
}

variable "tf_azs" {
    description = "Run EC2 instances in these availability zones"
#    type       = "list"
#    default    = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
    default     = "eu-west-1a,eu-west-1b,eu-west-1c"
}

variable "tf_openvpn_az" {
    default	= "eu-west-1a"
}

variable "tf_hegz_private_cidr_block" {
    description = "list of private subnet cidr blocks"
#    type       = "list"
#    default    = ["172.20.1.0/24", "172.20.2.0/24", "172.20.3.0/24"]
    default     = "172.20.1.0/24,172.20.2.0/24,172.20.3.0/24"
}

variable "tf_hegz_public_cidr_block" {
    description = "list of public subnet cidr blocks"
#    type	= "list"
    default     = "172.20.101.0/24,172.20.102.0/24,172.20.103.0/24"
}

variable "tf_public_subnets_count" {
    default 	= 3
}

variable "tf_private_subnets_count" {
    default 	= 3
}

variable "tf_aws_instance_type" {
    default 	= "t2.micro"
}
variable "tf_aws_image_id" {
    default 	= "ami-7abd0209"       /* Centos 7 */
}

variable "tf_etcd_instances_count" {
    default 	= 3
}

variable "tf_openvpn_instances_count" {
    default     = 1
}

variable "tf_etcd_sg1_name"	{
    default	= "hegz-etcd-sg1"
}

variable "tf_openvpn_sg1_name"        {
    default     = "hegz-openvpn-sg1"
}

variable "tf_aws_etcd_key_name" {
    default 	= "hegz-etcd-cluster"
}

variable "tf_aws_openvpn_key_name" {
    default = "hegz-openvpn-server"
}

variable "tf_elb_sg1_name" {
    default = "hegz-elb-sg1-name"
}


