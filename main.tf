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

module "app" {
  source = "./modules/bitwarden-app"

  stage         = var.stage
  subnet_id     = module.root.public_subnet_ids[0]
  sg_ids        = module.root.app_instance_sg_ids
  instance_type = "t4g.micro"
  pubkey        = local.app_env_secrets.app_instance_public_key
}

module "end" {
  source = "./modules/bitwarden-end"

  stage                  = var.stage
  domain                 = var.domain
  route53_apex_zone_id   = data.aws_route53_zone.apex.zone_id
  route53_default_ttl    = 3600
  app_instance_public_ip = module.app.instance_public_ip
}

module "provision" {
  source = "./modules/bitwarden-provision"
  depends_on = [
    module.root,
    module.app,
    module.end,
  ]

  stage                  = var.stage
  domain                 = var.domain
  app_instance_public_ip = module.app.instance_public_ip
  app_keypair_path       = "${path.root}/${local.keypair_filename}"
  service_user_password  = local.app_env_secrets.service_user_password
}
