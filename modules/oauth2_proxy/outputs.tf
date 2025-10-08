output "prometheus_cookie_secret" {
  description = "The generated cookie secret for Prometheus OAuth2 Proxy"
  value       = random_password.prometheus_cookie_secret.result
  sensitive   = true
}

output "alertmanager_cookie_secret" {
  description = "The generated cookie secret for Alertmanager OAuth2 Proxy"
  value       = random_password.alertmanager_cookie_secret.result
  sensitive   = true
}

output "session_storage_secret" {
  description = "The generated session storage password shared by Prometheus and Alertmanager"
  value       = random_password.session_storage_secret.result
  sensitive   = true
}
