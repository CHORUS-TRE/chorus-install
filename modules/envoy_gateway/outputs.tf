output "loadbalancer_ip" {
  description = "LoadBalancer IP address of the Envoy Gateway"
  value       = try(data.kubernetes_service.gateway_envoy.status.0.load_balancer.0.ingress.0.ip, null)
  depends_on  = [null_resource.wait_for_gateway_lb_ip]
}
