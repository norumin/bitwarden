output "app_url" {
  description = "URL for this app"
  value       = "https://${var.domain}"
}

output "app_instance_public_ip" {
  description = "Public IP of app instance"
  value       = module.app.instance_public_ip
  sensitive   = true
}

output "cmd_ssh_to_app_instance" {
  description = "Command to ssh into app instance"
  value       = "ssh -i ${local.keypair_filename} -o IdentitiesOnly=yes ubuntu@${module.app.instance_public_ip}"
  sensitive   = true
}

output "cmd_bitwarden_installer" {
  description = "Command to run to bitwarden installer playbook"
  value       = module.provision.cmd_bitwarden_installer
  sensitive   = true
}
