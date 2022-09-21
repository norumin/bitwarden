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
