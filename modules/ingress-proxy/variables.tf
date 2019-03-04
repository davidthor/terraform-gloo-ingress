variable "namespace" {
  type = "string"
}

variable "xds_port" {
  type = "string"
}

variable "replicas" {
  type = "string"
  default = 1
}

variable "container_image" {
  type = "string"
  default = "soloio/gloo-envoy-wrapper"
}

variable "container_tag" {
  type = "string"
  default = "0.8.6"
}

variable "http_port" {
  type = "string"
  default = 80
}

variable "https_port" {
  type = "string"
  default = 443
}
