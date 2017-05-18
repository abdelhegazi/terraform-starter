provider "azurerm" {}

#resource "azurerm_storage_blob" "abdelSB-test1" {
#
##}
#
#data "template_file" "script" {
#
#  template = "${file(init.tpl)}"
#
#  vars {
#    id = "${azurerm_virtual_machine.abdelVM-test1-centos.id}"
#  }
#}
#
#data "template_cloudinit_config" "config" {
#  gzip		= true
#  base64_encode = true
#
#  part {
#    filename	 = "init.cfg"
#    content_type = "text/part-handler"
#    content	 = "${data.template_file.script.rendered}"
#  }
#
#  part {
#    content_type = "text/x-shellscript"
#    content	 = "baz"
#  }
#
#  part {
#    content_type = "text/x-shellscript"
#    content	 = "ffbaz"
#  }
#}
#
#

