resource "aws_route53_record" "subdomain" {
  zone_id = var.route53_apex_zone_id
  name    = var.domain
  type    = "A"
  ttl     = var.route53_default_ttl

  records = [
    var.app_instance_public_ip,
  ]
}
