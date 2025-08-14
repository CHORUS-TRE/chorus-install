output "loadbalancer_ip" {
  value      = try(data.kubernetes_service.loadbalancer.status.0.load_balancer.0.ingress.0.ip, null)
  depends_on = [null_resource.wait_for_lb_ip]
}