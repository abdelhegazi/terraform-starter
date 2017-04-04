#/* Etcd AZA Instance */#
resource "aws_instance" "etcd_instances" {
  count                  = "${var.mod_etcd_instances_count}"
  ami                    = "${var.mod_ami}"
  instance_type          = "${var.mod_instance_type}"
  availability_zone      = "${element(split(",", var.mod_azs), count.index)}"
  key_name               = "${var.mod_key_name}"
  vpc_security_group_ids = ["${aws_security_group.etcd_sg1.id}"]
  subnet_id              = "${element(split(",", var.mod_privsn_ids), count.index)}"
  monitoring             = true

  user_data = <<-EOF
        #!/bin/bash
        yum -y update
      	yum install epel-release
      	yum install etcd
      	systemctl start etcd
        EOF

  tags {
    Name           = "hegz_etcd_node_${count.index}"
    ansible_filter = "hegz_etcd_node_${count.index}"
  }
}

#/* Etcd Security Group */#
resource "aws_security_group" "etcd_sg1" {
  vpc_id      = "${var.mod_vpc_id}"
  name        = "${var.mod_etcd_sg1_name}"
  description = "allowing [ssh, icmp, http, etcd] in and no blocking on the outgoing traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #    ingress {


  #        from_port       = -1


  #        to_port         = -1


  #        protocol        = "icmp"


  #        cidr_blocks     = ["0.0.0.0/0"]


  #    }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 2379
    to_port     = 2379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 2380
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name           = "hegz_etcd_sg1"
    ansible_filter = "hegz_etcd_sg1"
  }
}
