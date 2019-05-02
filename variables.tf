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
  default = "quay.io/solo-io/gloo"
}

variable "gloo_service_image_tag" {
  default = "0.13.19"
}

variable "discovery_service_replicas" {
  default = 1
}

variable "discovery_service_image" {
  default = "quay.io/solo-io/discovery"
}

variable "discovery_service_image_tag" {
  default = "0.13.19"
}

variable "ingress_service_replicas" {
  default = 1
}

variable "ingress_service_image" {
  default = "quay.io/solo-io/ingress"
}

variable "ingress_service_image_tag" {
  default = "0.13.19"
}

variable "ingress_proxy_service_replicas" {
  default = 1
}

variable "ingress_proxy_service_image" {
  default = "quay.io/solo-io/gloo-envoy-wrapper"
}

variable "ingress_proxy_service_image_tag" {
  default = "0.13.19"
}

variable "proxy_http_port" {
  default = 80
}

variable "proxy_https_port" {
  default = 443
}

variable "kubeconfig_file_path" {
  default = ""
}
