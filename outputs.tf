output "namespace" {
  value = "${kubernetes_namespace.gloo_namespace.metadata.0.name}"
}

output "load_balancer_ingress" {
  value = "${kubernetes_service.ingress_proxy.load_balancer_ingress.0.ip}"
}
