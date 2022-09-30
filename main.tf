variable "app_name" {
  description = "Name of this app"
  type        = string
  default     = "Norumin Password Vault"
}

variable "app" {
  description = "URL friendly name of this app"
  type        = string
  default     = "bitwarden"
}

variable "stage" {
  description = "Stage of deployment"
  type        = string
  default     = "production"
}

variable "domain" {
  description = "Domain of this app"
  type        = string
  default     = "bitwarden.norumin.com"
}

locals {

}

module "root" {
  source = "./modules/bitwarden-root"

  app_name    = var.app_name
  app         = var.app
  stage       = var.stage
  vpc_cidr    = "10.0.0.0/16"
  vpc_subnets = 3
}

module "app" {
  source = "./modules/bitwarden-app"

  app_name      = var.app_name
  app           = var.app
  stage         = var.stage
  subnet_id     = module.root.public_subnet_ids[0]
  sg_ids        = module.root.app_instance_sg_ids
  instance_type = "t3.small"
  pubkey        = trimspace(local.app_env_secrets.app_instance_public_key)
}

module "end" {
  source = "./modules/bitwarden-end"

  app_name               = var.app_name
  app                    = var.app
  stage                  = var.stage
  domain                 = var.domain
  app_instance_public_ip = module.app.instance_public_ip
}

module "provision" {
  source = "./modules/bitwarden-provision"
  depends_on = [
    module.root,
    module.app,
    module.end,
  ]

  app_name                   = var.app_name
  app                        = var.app
  stage                      = var.stage
  domain                     = var.domain
  letsencrypt_contact_email  = local.app_env_secrets.bitwarden_installation_email
  app_instance_public_ip     = module.app.instance_public_ip
  app_keypair_path           = "${path.root}/${local.keypair_filename}"
  bitwarden_installation_id  = local.app_env_secrets.bitwarden_installation_id
  bitwarden_installation_key = local.app_env_secrets.bitwarden_installation_key
}

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
