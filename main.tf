provider "kubernetes" {}

resource "kubernetes_namespace" "gloo_namespace" {
  metadata {
    name = "${var.namespace}"
  }
}

module "settings" {
  source = "./modules/settings"
  namespace = "${kubernetes_namespace.gloo_namespace.metadata.0.name}"
  xds_port = "${var.xds_port}"
}

module "cluster_role" {
  source = "./modules/cluster-role"
  namespace = "${kubernetes_namespace.gloo_namespace.metadata.0.name}"
}

module "gloo" {
  source = "./modules/gloo"
  namespace = "${kubernetes_namespace.gloo_namespace.metadata.0.name}"
  xds_port = "${var.xds_port}"
}

module "discovery" {
  source = "./modules/discovery"
  namespace = "${kubernetes_namespace.gloo_namespace.metadata.0.name}"
}

module "ingress" {
  source = "./modules/ingress"
  namespace = "${kubernetes_namespace.gloo_namespace.metadata.0.name}"
}

module "ingress_proxy" {
  source = "./modules/ingress-proxy"
  namespace = "${kubernetes_namespace.gloo_namespace.metadata.0.name}"
  xds_port = "${var.xds_port}"
}
