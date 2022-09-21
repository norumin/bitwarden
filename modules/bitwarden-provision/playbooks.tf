resource "time_sleep" "initial_delay" {
  create_duration = "10s"
}

resource "null_resource" "bitwarden_installer" {
  depends_on = [
    time_sleep.initial_delay,
  ]

  triggers = {
    src_hash = filesha256("${path.module}/playbooks/bitwarden.yml")
    variables = jsonencode([
      var.app_instance_public_ip,
      var.app_keypair_path,
    ])
  }

  provisioner "local-exec" {
    command = <<BASH
      ANSIBLE_NOCOWS=1 ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook ${path.module}/playbooks/bitwarden.yml \
        -u ubuntu \
        -i '${var.app_instance_public_ip},' \
        --private-key ${var.app_keypair_path} \
        -e 'app_domain=${var.domain}' \
        -e 'bw_installid=${var.bitwarden_installation_id}' \
        -e 'bw_installkey=${var.bitwarden_installation_key}'
    BASH
  }
}
