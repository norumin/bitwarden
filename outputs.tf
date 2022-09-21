output "app_url" {
  description = "URL for this app"
  value       = "https://${var.domain}"
}

output "app_instance_public_ip" {
  description = "Public IP of app instance"
  value       = module.app.instance_public_ip
  sensitive   = true
}
