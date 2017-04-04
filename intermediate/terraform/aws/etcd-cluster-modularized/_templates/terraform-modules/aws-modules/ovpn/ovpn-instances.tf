#/ * OpenVPN Server EC2 Instances */#
resource "aws_instance" "openvpn_server" {
  count                       = "${var.mod_openvpn_instances_count}"
  ami                         = "${var.mod_ami}"
  instance_type               = "${var.mod_instance_type}"
  availability_zone           = "${var.mod_openvpn_az}"
  key_name                    = "${var.mod_key_name}"
  vpc_security_group_ids      = ["${aws_security_group.openvpn_sg1.id}"]
  subnet_id                   = "${element(split(",", var.mod_pubsn_ids), count.index)}"
  associate_public_ip_address = true
  monitoring                  = true

  user_data = <<-EOF
        #!/bin/bash
        yum -y update
        EOF

  tags {
    Name           = "hegz_openvpn_server"
    ansible_filter = "hegz_openvpn_server"
  }
}

// Allocating eip to the openvpn server
resource "aws_eip" "hegz_openvpn_server_eip" {
  instance = "${aws_instance.openvpn_server.id}"
}

#/* OpenVPN server Security Group */#
resource "aws_security_group" "openvpn_sg1" {
  vpc_id      = "${var.mod_vpc_id}"
  name        = "hegz_openvpn_sg1"
  description = "allowing [ssh, icmp, http, openvpn tcp,udp]"

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
    from_port   = 1194
    to_port     = 1194
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name           = "hegz_openvpn_sg1"
    ansible_filter = "hegz_openvpn_sg1"
  }
}
