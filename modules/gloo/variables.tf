variable "namespace" {
  type = "string"
}

variable "service_account_name" {
  type = "string"
}

variable "service_account_secret_name" {
  type = "string"
}

variable "replicas" {
  type = "string"
  default = 1
}

variable "xds_port" {
  type = "string"
}

variable "container_image" {
  type = "string"
  default = "soloio/gloo"
}

variable "container_tag" {
  type = "string"
  default = "0.8.6"
}
