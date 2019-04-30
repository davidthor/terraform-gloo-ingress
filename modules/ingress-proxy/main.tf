data "template_file" "envoy_config" {
  template = "${file("${path.module}/envoy-config.yml.tpl")}"

  vars {
    GLOO_SERVICE_NAME = "gloo"
    XDS_PORT = "${var.xds_port}"
  }
}

resource "kubernetes_config_map" "ingress_envoy_config" {
  metadata {
    name = "ingress-envoy-config"
    namespace = "${var.namespace}"

    labels {
      app = "gloo"
    }
  }

  data {
    envoy.yaml = "${data.template_file.envoy_config.rendered}"
  }
}

resource "kubernetes_deployment" "ingress_proxy" {
  metadata {
    name = "ingress-proxy"
    namespace = "${var.namespace}"

    labels {
      app = "gloo"
      gloo = "ingress-proxy"
    }
  }

  spec {
    replicas = "${var.replicas}"

    selector {
      match_labels {
        gloo = "ingress-proxy"
      }
    }

    template {
      metadata {
        labels {
          gloo = "ingress-proxy"
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

        volume {
          name = "envoy-config"

          config_map {
            name = "${kubernetes_config_map.ingress_envoy_config.metadata.0.name}"
          }
        }

        container {
          name = "ingress-proxy"
          image = "${var.container_image}:${var.container_tag}"
          image_pull_policy = "Always"
          args = ["--disable-hot-restart"]

          volume_mount {
            mount_path = "/etc/envoy"
            name = "envoy-config"
          }

          volume_mount {
            mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"
            name = "${var.service_account_secret_name}"
            read_only = true
          }

          port {
            name = "http"
            protocol = "TCP"
            container_port = "${var.http_port}"
          }

          port {
            name = "https"
            protocol = "TCP"
            container_port = "${var.https_port}"
          }

          env {
            name = "POD_NAMESPACE"

            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }

          env {
            name = "POD_NAME"

            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "ingress_proxy" {
  metadata {
    name = "ingress-proxy"
    namespace = "${var.namespace}"

    labels {
      app = "gloo"
      gloo = "ingress-proxy"
    }
  }

  spec {
    type = "LoadBalancer"

    selector {
      gloo = "ingress-proxy"
    }

    port {
      name = "http"
      protocol = "TCP"
      port = "${var.http_port}"
    }

    port {
      name = "https"
      protocol = "TCP"
      port = "${var.https_port}"
    }
  }
}
