resource "kubernetes_namespace" "gloo_namespace" {
  metadata {
    name = "${var.namespace}"
  }
}
