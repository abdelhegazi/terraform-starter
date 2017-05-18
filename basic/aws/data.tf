### an example of how data sources work
# Find the latest available AMI that is tagged with Component = web

data "aws_ami" "web" {
  filter {
    name = "state"
    values = "available"
  }

  filter {
    name =  "tag:component"
    values = ["web"]
  }

  most_recent = true
}


resource "aws_instance" "web" {
  ami	= "${data.aws_ami.web.id}"
  instance_type	=  "t1.micro"
}

