provider "kubernetes" {}

resource "kubernetes_deployment" "gloo_discovery" {
  metadata {
    name = "discovery"
    namespace = "${var.namespace}"

    labels {
      app = "gloo"
      gloo = "discovery"
    }
  }

  spec {
    replicas = "${var.replicas}"

    selector {
      match_labels {
        gloo = "discovery"
      }
    }

    template {
      metadata {
        labels {
          gloo = "discovery"
        }
      }

      spec {
        container {
          name = "discovery"
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
