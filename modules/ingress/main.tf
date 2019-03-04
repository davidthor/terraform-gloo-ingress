provider "kubernetes" {}

resource "kubernetes_deployment" "ingress" {
  metadata {
    name = "ingress"
    namespace = "${var.namespace}"

    labels {
      app = "gloo"
      gloo = "ingress"
    }
  }

  spec {
    replicas = "${var.replicas}"

    selector {
      match_labels {
        gloo = "ingress"
      }
    }

    template {
      metadata {
        labels {
          gloo = "ingress"
        }
      }

      spec {
        container {
          name = "ingress"
          image = "${var.container_image}:${var.container_tag}"
          image_pull_policy = "Always"

          env {
            name = "POD_NAMESPACE"

            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }
        }
      }
    }
  }
}
