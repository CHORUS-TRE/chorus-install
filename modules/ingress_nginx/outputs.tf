output "loadbalancer_ip" {
  value      = data.kubernetes_service.loadbalancer.status.0.load_balancer.0.ingress.0.ip
  depends_on = [null_resource.wait_for_lb_ip]
}