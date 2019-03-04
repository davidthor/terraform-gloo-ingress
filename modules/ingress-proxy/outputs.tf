output "load_balancer_ingress" {
  value = "${kubernetes_service.ingress_proxy.load_balancer_ingress.0.ip}"
}
