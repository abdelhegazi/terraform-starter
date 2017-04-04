variable "key" {
    default = "hello"
}

variable "filename" {
    default = "template.txt"
}

resource "template_file" "template_sample" {
    filename = "${var.filename}"
    vars {
        hello = "${var.key}"
        world = "${replace(var.key, "ello", "XXXX")}"
    }
}

# AMI is for Debian 7.8, latest from Debian Wiki
#resource "aws_instance" "example" {
#    ami = "ami-e0efab88"
#    instance_type = "t2.micro"
#    user_data = "${template_file.template_sample.rendered}"
#}

output "rendered" {
    value = "${template_file.template_sample.rendered}"
}
