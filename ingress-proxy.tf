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
    namespace = "${kubernetes_namespace.gloo_namespace.metadata.0.name}"

    labels {
      app = "gloo"
      gloo = "gateway-proxy"
    }
  }

  data {
    envoy.yaml = "${data.template_file.envoy_config.rendered}"
  }
}

resource "kubernetes_deployment" "ingress_proxy" {
  metadata {
    name = "ingress-proxy"
    namespace = "${kubernetes_namespace.gloo_namespace.metadata.0.name}"

    labels {
      app = "gloo"
      gloo = "ingress-proxy"
    }
  }

  spec {
    replicas = "${var.ingress_proxy_service_replicas}"

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
        service_account_name = "${kubernetes_service_account.gloo_service_account.metadata.0.name}"

        volume {
          name = "${kubernetes_service_account.gloo_service_account.default_secret_name}"
          secret {
            secret_name = "${kubernetes_service_account.gloo_service_account.default_secret_name}"
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
          image = "${var.ingress_proxy_service_image}:${var.ingress_proxy_service_image_tag}"
          image_pull_policy = "Always"
          args = ["--disable-hot-restart"]

          security_context {
            read_only_root_filesystem = true
            allow_privilege_escalation = false

            capabilities {
              drop = ["ALL"]
              add = ["NET_BIND_SERVICE"]
            }
          }

          volume_mount {
            mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"
            name = "${kubernetes_service_account.gloo_service_account.default_secret_name}"
            read_only = true
          }

          volume_mount {
            mount_path = "/etc/envoy"
            name = "envoy-config"
          }

          port {
            name = "http"
            protocol = "TCP"
            container_port = "${var.proxy_http_port}"
          }

          port {
            name = "https"
            protocol = "TCP"
            container_port = "${var.proxy_https_port}"
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
    namespace = "${kubernetes_namespace.gloo_namespace.metadata.0.name}"

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
      port = "${var.proxy_http_port}"
    }

    port {
      name = "https"
      protocol = "TCP"
      port = "${var.proxy_https_port}"
    }
  }
}
