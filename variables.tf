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
