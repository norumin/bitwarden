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

variable "module" {
  description = "Module name"
  type        = string
  default     = "provision"
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

variable "cert" {
  description = "SSL certificate"
  type = object({
    certificate_pem = string
    private_key_pem = string
    issuer_pem      = string
  })
  sensitive = true
}

variable "app_instance_public_ip" {
  description = "Public IP address of the app instance"
  type        = string
  sensitive   = true
}

variable "app_keypair_path" {
  description = "Path to keypair file for ssh connection to the app instance"
  type        = string
  sensitive   = true
}

variable "bitwarden_installation_id" {
  description = "Installation ID of this Bitwarden hosting"
  type        = string
  sensitive   = true
}

variable "bitwarden_installation_key" {
  description = "Installation key of this Bitwarden hosting"
  type        = string
  sensitive   = true
}
