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
        service_account_name = "${var.service_account_name}"

        volume {
          name = "${var.service_account_secret_name}"

          secret {
            secret_name = "${var.service_account_secret_name}"
          }
        }

        container {
          name = "discovery"
          image = "${var.container_image}:${var.container_tag}"
          image_pull_policy = "Always"

          volume_mount {
            mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"
            name = "${var.service_account_secret_name}"
            read_only = true
          }

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
