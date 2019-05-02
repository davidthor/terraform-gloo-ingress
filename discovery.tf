resource "kubernetes_deployment" "gloo_discovery" {
  metadata {
    name = "discovery"
    namespace = "${kubernetes_namespace.gloo_namespace.metadata.0.name}"

    labels {
      app = "gloo"
      gloo = "discovery"
    }
  }

  spec {
    replicas = "${var.discovery_service_replicas}"

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
        service_account_name = "${kubernetes_service_account.gloo_service_account.metadata.0.name}"

        volume {
          name = "${kubernetes_service_account.gloo_service_account.default_secret_name}"
          secret {
            secret_name = "${kubernetes_service_account.gloo_service_account.default_secret_name}"
          }
        }

        container {
          name = "discovery"
          image = "${var.discovery_service_image}:${var.discovery_service_image_tag}"
          image_pull_policy = "Always"

          volume_mount {
            mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"
            name = "${kubernetes_service_account.gloo_service_account.default_secret_name}"
            read_only = true
          }

          security_context {
            read_only_root_filesystem = true
            allow_privilege_escalation = false
            run_as_non_root = true
            run_as_user = 10101

            capabilities {
              drop = ["ALL"]
            }
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
