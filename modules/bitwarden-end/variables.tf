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
  default     = "end"
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

variable "route53_default_ttl" {
  description = "Default TTL for DNS records"
  type        = string
  default     = 3600
}

variable "app_instance_public_ip" {
  description = "Public IP address of the app instance"
  type        = string
  sensitive   = true
}
