variable "namespace" {
  type = "string"
}

variable "replicas" {
  type = "string"
  default = 1
}

variable "container_image" {
  type = "string"
  default = "soloio/ingress"
}

variable "container_tag" {
  type = "string"
  default = "0.8.6"
}
