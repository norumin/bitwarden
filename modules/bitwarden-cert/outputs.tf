output "certificate_pem" {
  description = "Certificate in PEM format"
  value       = lookup(acme_certificate.certificate, "certificate_pem")
  sensitive   = true
}

output "issuer_pem" {
  description = "Issuer certificate in PEM format"
  value       = lookup(acme_certificate.certificate, "issuer_pem")
  sensitive   = true
}

output "private_key_pem" {
  description = "Private key in PEM format"
  value       = lookup(acme_certificate.certificate, "private_key_pem")
  sensitive   = true
}
