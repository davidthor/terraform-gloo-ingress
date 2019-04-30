resource "kubernetes_deployment" "gloo" {
  metadata {
    name = "gloo"
    namespace = "${var.namespace}"

    labels {
      app = "gloo"
      gloo = "gloo"
    }
  }

  spec {
    replicas = "${var.replicas}"

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
        service_account_name = "${var.service_account_name}"

        volume {
          name = "${var.service_account_secret_name}"

          secret {
            secret_name = "${var.service_account_secret_name}"
          }
        }

        container {
          name = "gloo"
          image = "${var.container_image}:${var.container_tag}"
          image_pull_policy = "Always"

          port {
            container_port = "${var.xds_port}"
            name = "grpc"
            protocol = "TCP"
          }

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

resource "kubernetes_service" "gloo" {
  metadata {
    name = "gloo"
    namespace = "${var.namespace}"

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
