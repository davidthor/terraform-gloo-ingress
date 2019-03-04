provider "kubernetes" {}

resource "kubernetes_cluster_role" "gloo_role" {
  metadata {
    name = "gloo-role"
  }

  rule {
    api_groups = [""]
    resources = ["pods", "services", "secrets", "endpoints", "configmaps"]
    verbs = ["*"]
  }

  rule {
    api_groups = [""]
    resources = ["namespaces"]
    verbs = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["apiextensions.k8s.io"]
    resources = ["customresourcedefinitions"]
    verbs = ["get", "create"]
  }

  rule {
    api_groups = ["apiextensions.k8s.io"]
    resources = ["customresourcedefinitions"]
    verbs = ["get", "create"]
  }

  rule {
    api_groups = ["gloo.solo.io"]
    resources = ["settings", "upstreams", "proxies","virtualservices"]
    verbs = ["*"]
  }

  rule {
    api_groups = ["extensions", ""]
    resources = ["ingresses"]
    verbs = ["*"]
  }
}

resource "kubernetes_cluster_role_binding" "gloo_role_binding" {
  metadata {
    name = "gloo-role-binding"
  }

  role_ref {
    kind = "ClusterRole"
    api_group = "rbac.authorization.k8s.io"
    name = "${kubernetes_cluster_role.gloo_role.metadata.0.name}"
  }

  subject {
    kind = "ServiceAccount"
    name = "${var.service_account}"
    namespace = "${var.namespace}"
    api_group = ""
  }
}
