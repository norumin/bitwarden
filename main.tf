terraform {
  required_version = ">= 1.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.21"
    }
  }
}

module "root" {
  source = "./modules/bitwarden-root"

  stage       = var.stage
  vpc_cidr    = "10.0.0.0/16"
  vpc_subnets = 3
}

module "cert" {
  source = "./modules/bitwarden-cert"

  stage         = var.stage
  domain        = var.domain
  email_address = local.app_env_secrets.bitwarden_installation_email
}

module "app" {
  source = "./modules/bitwarden-app"

  stage         = var.stage
  subnet_id     = module.root.public_subnet_ids[0]
  sg_ids        = module.root.app_instance_sg_ids
  instance_type = "t3.small"
  pubkey        = local.app_env_secrets.app_instance_public_key
}

module "end" {
  source = "./modules/bitwarden-end"

  stage                  = var.stage
  domain                 = var.domain
  app_instance_public_ip = module.app.instance_public_ip
}

module "provision" {
  source = "./modules/bitwarden-provision"
  depends_on = [
    module.root,
    module.cert,
    module.app,
    module.end,
  ]

  stage                      = var.stage
  domain                     = var.domain
  cert                       = module.cert.cert
  app_instance_public_ip     = module.app.instance_public_ip
  app_keypair_path           = "${path.root}/${local.keypair_filename}"
  bitwarden_installation_id  = local.app_env_secrets.bitwarden_installation_id
  bitwarden_installation_key = local.app_env_secrets.bitwarden_installation_key
}
