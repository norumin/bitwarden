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
  default     = "cert"
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

variable "email_address" {
  description = "Email address for ACME registration"
  type        = string
}

variable "create_acm_certificate" {
  description = "Whether to create ACM certificate or not"
  type        = bool
  default     = false
}
