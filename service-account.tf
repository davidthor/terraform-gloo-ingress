resource "kubernetes_service_account" "gloo_service_account" {
  metadata {
    name = "${var.service_account_name}"
    namespace = "${kubernetes_namespace.gloo_namespace.metadata.0.name}"
  }
}
