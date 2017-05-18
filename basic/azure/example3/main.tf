resource "null_resource" "export_rendered_template" {
  provisioner "local-exec" {
    command = "cat > test_output.json" <<EOL\n${data.template_file.test.rendered}\nEOL
  }
}

data "template_file" "test" {
  count = "${length(var.alist)}"
  template = "${file("./tpl.json")}"
  vars {
    variable = "${var.myvar}"
  }
}

