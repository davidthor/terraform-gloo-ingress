resource "kubernetes_deployment" "ingress" {
  metadata {
    name = "ingress"
    namespace = "${kubernetes_namespace.gloo_namespace.metadata.0.name}"

    labels {
      app = "gloo"
      gloo = "ingress"
    }
  }

  spec {
    replicas = "${var.ingress_service_replicas}"

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
        service_account_name = "${kubernetes_service_account.gloo_service_account.metadata.0.name}"

        volume {
          name = "${kubernetes_service_account.gloo_service_account.default_secret_name}"
          secret {
            secret_name = "${kubernetes_service_account.gloo_service_account.default_secret_name}"
          }
        }

        container {
          name = "ingress"
          image = "${var.ingress_service_image}:${var.ingress_service_image_tag}"
          image_pull_policy = "Always"

          volume_mount {
            mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"
            name = "${kubernetes_service_account.gloo_service_account.default_secret_name}"
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
