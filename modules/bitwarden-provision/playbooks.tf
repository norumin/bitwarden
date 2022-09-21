resource "time_sleep" "initial_delay" {
  create_duration = "10s"
}

resource "null_resource" "app_instance_provisioner" {
  depends_on = [
    time_sleep.initial_delay,
  ]

  triggers = {
    src_hash = filesha256("${path.module}/playbooks/app.yml")
    variables = jsonencode([
      var.app_instance_public_ip,
      var.app_keypair_path,
    ])
  }

  provisioner "local-exec" {
    command = <<BASH
      ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook ${path.module}/playbooks/app.yml \
        -u ubuntu \
        -i '${var.app_instance_public_ip},' \
        --private-key ${var.app_keypair_path}
    BASH
  }
}
