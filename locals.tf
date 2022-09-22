locals {
  app_env_secrets           = jsondecode(data.aws_secretsmanager_secret_version.app_env.secret_string)
  app_container_name_prefix = "app"
  keypair_filename          = ".keypair.pem"
  cert_dir_path             = "${abspath(path.root)}/certs"
}
