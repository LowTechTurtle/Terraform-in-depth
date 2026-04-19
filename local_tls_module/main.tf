variable "domains" {
  type    = set(string)
  default =[
    "example.com",
    "bravo.example.com",
    "charilie.example.com",
  ]
}

resource "tls_private_key" "ca_key" {
  algorithm = "ED25519"
}

resource "tls_self_signed_cert" "ca_cert" {
  private_key_pem   = tls_private_key.ca_key.private_key_pem
  is_ca_certificate = true

  subject {
    common_name  = "TiD CA"
    organization = "Terraform in Depth"
  }

  validity_period_hours = 24

  allowed_uses =[
    "digital_signature",
    "cert_signing",
    "crl_signing"
  ]
}

resource "tls_private_key" "child_key" {
  for_each  = var.domains
  algorithm = "ECDSA"
}

resource "tls_cert_request" "child_request" {
  for_each        = var.domains
  private_key_pem = tls_private_key.child_key[each.value].private_key_pem

  subject {
    common_name  = "example.com"
    organization = "Terraform in Depth"
  }
}

resource "tls_locally_signed_cert" "child_certificate" {
  for_each         = var.domains
  cert_request_pem = tls_cert_request.child_request[each.value].cert_request_pem

  ca_private_key_pem = tls_private_key.ca_key.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca_cert.cert_pem

  validity_period_hours = 12

  allowed_uses =[
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}
