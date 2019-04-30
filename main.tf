resource "kubernetes_namespace" "gloo_namespace" {
  metadata {
    name = "${var.namespace}"
  }
}

resource "kubernetes_service_account" "gloo_service_account" {
  metadata {
    name = "${var.service_account_name}"
    namespace = "${kubernetes_namespace.gloo_namespace.metadata.0.name}"
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
  service_account = "${kubernetes_service_account.gloo_service_account.metadata.0.name}"
}

module "gloo" {
  source = "./modules/gloo"
  namespace = "${kubernetes_namespace.gloo_namespace.metadata.0.name}"
  xds_port = "${var.xds_port}"
  service_account_name = "${kubernetes_service_account.gloo_service_account.metadata.0.name}"
  service_account_secret_name = "${kubernetes_service_account.gloo_service_account.default_secret_name}"
}

module "discovery" {
  source = "./modules/discovery"
  namespace = "${kubernetes_namespace.gloo_namespace.metadata.0.name}"
  service_account_name = "${kubernetes_service_account.gloo_service_account.metadata.0.name}"
  service_account_secret_name = "${kubernetes_service_account.gloo_service_account.default_secret_name}"
}

module "ingress" {
  source = "./modules/ingress"
  namespace = "${kubernetes_namespace.gloo_namespace.metadata.0.name}"
  service_account_name = "${kubernetes_service_account.gloo_service_account.metadata.0.name}"
  service_account_secret_name = "${kubernetes_service_account.gloo_service_account.default_secret_name}"
}

module "ingress_proxy" {
  source = "./modules/ingress-proxy"
  namespace = "${kubernetes_namespace.gloo_namespace.metadata.0.name}"
  xds_port = "${var.xds_port}"
  service_account_name = "${kubernetes_service_account.gloo_service_account.metadata.0.name}"
  service_account_secret_name = "${kubernetes_service_account.gloo_service_account.default_secret_name}"
}
