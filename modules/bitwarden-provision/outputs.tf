output "cmd_bitwarden_installer" {
  description = "Command to run to bitwarden installer playbook"
  value       = local.cmd_bitwarden_installer
  sensitive   = true
}
