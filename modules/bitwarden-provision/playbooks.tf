resource "time_sleep" "initial_delay" {
  create_duration = "10s"
}

resource "null_resource" "bitwarden_installer" {
  depends_on = [
    time_sleep.initial_delay,
  ]

  triggers = {
    src_hash = filesha256("${path.module}/playbooks/bitwarden.yml")
    dependencies = jsonencode([
      var.domain,
      var.letsencrypt_contact_email,
      var.app_instance_public_ip,
      var.app_keypair_path,
      var.bitwarden_installation_id,
      var.bitwarden_installation_key,
    ])
  }

  provisioner "local-exec" {
    command = local.cmd_bitwarden_installer
  }

  lifecycle {
    create_before_destroy = true
  }
}
