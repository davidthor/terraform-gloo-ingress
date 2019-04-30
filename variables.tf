variable "namespace" {
  type = "string"
  default = "gloo-system"
}

variable "service_account_name" {
  type = "string"
  default = "gloo"
}

variable "xds_port" {
  type = "string"
  default = 9977
}

variable "gloo_service_replicas" {
  default = 1
}

variable "gloo_service_image" {
  default = "soloio/gloo"
}

variable "gloo_service_image_tag" {
  default = "0.8.6"
}

variable "discovery_service_replicas" {
  default = 1
}

variable "discovery_service_image" {
  default = "soloio/discovery"
}

variable "discovery_service_image_tag" {
  default = "0.8.6"
}

variable "ingress_service_replicas" {
  default = 1
}

variable "ingress_service_image" {
  default = "soloio/ingress"
}

variable "ingress_service_image_tag" {
  default = "0.8.6"
}

variable "ingress_proxy_service_replicas" {
  default = 1
}

variable "ingress_proxy_service_image" {
  default = "soloio/gloo-envoy-wrapper"
}

variable "ingress_proxy_service_image_tag" {
  default = "0.8.6"
}

variable "proxy_http_port" {
  default = 80
}

variable "proxy_https_port" {
  default = 443
}
