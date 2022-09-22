resource "time_sleep" "initial_delay" {
  create_duration = "10s"
}

resource "null_resource" "bitwarden_installer" {
  depends_on = [
    time_sleep.initial_delay,
  ]

  triggers = {
    src_hash = filesha256("${path.module}/playbooks/bitwarden.yml")
    dependencies = sha256(jsonencode([
      var.domain,
      var.cert_path,
      fileexists("${var.cert_path}/certificate.crt") ? filesha256("${var.cert_path}/certificate.crt") : null,
      fileexists("${var.cert_path}/private.key") ? filesha256("${var.cert_path}/private.key") : null,
      fileexists("${var.cert_path}/ca.crt") ? filesha256("${var.cert_path}/ca.crt") : null,
      var.app_instance_public_ip,
      var.app_keypair_path,
      var.bitwarden_installation_id,
      var.bitwarden_installation_key,
    ]))
  }

  provisioner "local-exec" {
    command = local.cmd_bitwarden_installer
  }

  lifecycle {
    create_before_destroy = true
  }
}
