#/* ELB */#

resource "aws_elb" "hegz_etcd_elb" {
  name = "${var.mod_elb_sg1_name}"

  #    security_groups     = "${join(",", ["${var.mod_etcd.sg1.id}","${aws_security_group.etcd_elb_sg1.id}"]}"
  subnets   = ["${aws_subnet.hegz_pubsn.*.id}"]
  instances = ["${var.mod_etcd_instances_ids}"]

  # listener {


  #   instance_port     = 2379


  #   instance_protocol = "tcp"


  #   lb_port           = 2379


  #   lb_protocol       = "tcp"


  # }

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 3
    target              = "tcp:80"
    interval            = 30
  }
  tags {
    Name           = "hegz_etcd_elb"
    ansible_filter = "hegz_etcd_elb"
  }
}

// BEGIN ELB security group

resource "aws_security_group" "etcd_elb_sg1" {
  vpc_id      = "${var.mod_vpc_id}"
  name        = "hegz_elb_sg1"
  description = "allowing ONLY inbound etcd, http, icmp traffic"

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

  #    ingress {


  #        from_port       = 2380


  #        to_port         = 2380


  #        protocol        = "tcp"


  #        cidr_blocks     = ["0.0.0.0/0"]


  #    }


  #    egress {


  #        from_port       = 0


  #        to_port         = 0


  #        protocol        = -1


  #        cidr_blocks     = ["0.0.0.0/0"]


  #    }

  tags {
    Name           = "hegz_elb_sg1"
    ansible_filter = "hegz_elb_sg1"
  }
}

############################


## END ELB Security Group


############################

