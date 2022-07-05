output "docker_image_tag" {
  value = var.docker_image
}

output "task_definition_json" {
  value = data.template_file.this.rendered
}
