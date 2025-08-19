output "chorus_backend_private_key_pem" {
  value     = tls_private_key.chorus_backend_daemon.private_key_pem
  sensitive = true
}

output "chorus_backend_public_key_pem" {
  value = tls_private_key.chorus_backend_daemon.public_key_pem
}