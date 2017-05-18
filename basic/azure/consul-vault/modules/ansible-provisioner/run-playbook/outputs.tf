data "external" "dependency_hack" {
  depends_on = ["null_resource.run-ansible-playbook"]
  program = ["echo", "{ \"msg\": \"hack to get arround terraform depends_on short coming\" }"]
}

output "runbox_dependency_hack" {
  value = "${data.external.dependency_hack.result["msg"]}"
}
