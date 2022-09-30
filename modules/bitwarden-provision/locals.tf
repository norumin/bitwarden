locals {
  default_tags = {
    App    = var.app
    Module = var.module
    Stage  = var.stage
  }
  slug = "${var.app}-${var.module}-${var.stage}"

  cmd_bitwarden_installer = <<BASH
    ANSIBLE_NOCOWS=1 ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook ${path.module}/playbooks/bitwarden.yml \
      -u ubuntu \
      -i '${var.app_instance_public_ip},' \
      --private-key ${var.app_keypair_path} \
      -e 'app_domain=${var.domain}' \
      -e 'ssl_certificate_pem=${var.cert.certificate_pem}' \
      -e 'ssl_issuer_pem=${var.cert.issuer_pem}' \
      -e 'ssl_private_key_pem=${var.cert.private_key_pem}' \
      -e 'bw_installid=${var.bitwarden_installation_id}' \
      -e 'bw_installkey=${var.bitwarden_installation_key}'
  BASH
}
