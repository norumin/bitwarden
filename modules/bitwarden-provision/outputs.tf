output "cmd_bitwarden_installer" {
  description = "Command to run to bitwarden installer playbook"
  value       = <<BASH
    ANSIBLE_NOCOWS=1 ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook ${path.module}/playbooks/bitwarden.yml \
      -u ubuntu \
      -i '${var.app_instance_public_ip},' \
      --private-key ${var.app_keypair_path} \
      -e 'app_domain=${var.domain}' \
      -e 'ssl_server_cert=${var.cert.certificate_pem}' \
      -e 'ssl_private_key=${var.cert.private_key_pem}' \
      -e 'ssl_ca_cert=${var.cert.issuer_pem}' \
      -e 'bw_installid=${var.bitwarden_installation_id}' \
      -e 'bw_installkey=${var.bitwarden_installation_key}'
  BASH
  sensitive   = true
}
