output "docker_image_tag" {
  value = var.docker_image
}

output "task_definition_json" {
  value = data.template_file.this.rendered
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.this.arn
}
