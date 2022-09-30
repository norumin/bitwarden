resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "registration" {
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address   = var.email_address
}

resource "acme_certificate" "certificate" {
  account_key_pem           = acme_registration.registration.account_key_pem
  common_name               = var.domain
  subject_alternative_names = [var.domain]

  dns_challenge {
    provider = "route53"

    config = {
      AWS_HOSTED_ZONE_ID = data.aws_route53_zone.apex.zone_id
    }
  }

  depends_on = [
    acme_registration.registration,
  ]
}

resource "aws_acm_certificate" "certificate" {
  count = var.create_acm_certificate ? 1 : 0

  certificate_body  = acme_certificate.certificate.certificate_pem
  private_key       = acme_certificate.certificate.private_key_pem
  certificate_chain = acme_certificate.certificate.issuer_pem

  tags = {
    Name = var.domain
  }
}
