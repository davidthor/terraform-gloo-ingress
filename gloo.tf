resource "kubernetes_deployment" "gloo" {
  metadata {
    name = "gloo"
    namespace = "${kubernetes_namespace.gloo_namespace.metadata.0.name}"

    labels {
      app = "gloo"
      gloo = "gloo"
    }
  }

  spec {
    replicas = "${var.gloo_service_replicas}"

    selector {
      match_labels {
        gloo = "gloo"
      }
    }

    template {
      metadata {
        labels {
          gloo = "gloo"
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
          name = "gloo"
          image = "${var.gloo_service_image}:${var.gloo_service_image_tag}"
          image_pull_policy = "Always"

          volume_mount {
            mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"
            name = "${kubernetes_service_account.gloo_service_account.default_secret_name}"
            read_only = true
          }

          resources {
            requests {
              cpu = "1"
              memory = "256Mi"
            }
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

          port {
            container_port = "${var.xds_port}"
            name = "grpc"
            protocol = "TCP"
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

resource "kubernetes_service" "gloo" {
  metadata {
    name = "gloo"
    namespace = "${kubernetes_namespace.gloo_namespace.metadata.0.name}"

    labels {
      app = "gloo"
      gloo = "gloo"
    }
  }

  spec {
    selector {
      gloo = "gloo"
    }

    port {
      name = "grpc"
      port = "${var.xds_port}"
      protocol = "TCP"
    }
  }
}
