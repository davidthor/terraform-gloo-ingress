data "template_file" "gateway_resource" {
  template = "${file("${path.module}/custom-resources/gateway.yml")}"
}

data "template_file" "proxy_resource" {
  template = "${file("${path.module}/custom-resources/proxies.yml")}"
}

data "template_file" "settings_resource" {
  template = "${file("${path.module}/custom-resources/settings.yml")}"
}

data "template_file" "upstreams_resource" {
  template = "${file("${path.module}/custom-resources/upstreams.yml")}"
}

data "template_file" "upstream_groups_resource" {
  template = "${file("${path.module}/custom-resources/upstream-groups.yml")}"
}

data "template_file" "virtual_services_resource" {
  template = "${file("${path.module}/custom-resources/virtual-services.yml")}"
}

resource "null_resource" "gateway_resource" {
  depends_on = ["kubernetes_namespace.gloo_namespace"]

  triggers {
    manifest_sha1 = "${sha1(data.template_file.gateway_resource.rendered)}"
  }

  provisioner "local-exec" {
    command = "${var.kubeconfig_file_path != "" ? format(
      "export KUBECONFIG=%s && kubectl apply -f -<<EOF\n%s\nEOF",
      var.kubeconfig_file_path,
      data.template_file.gateway_resource.rendered
    ) : format(
      "kubectl apply -f -<<EOF\n%s\nEOF",
      data.template_file.gateway_resource.rendered
    )}"
  }
}

resource "null_resource" "proxy_resource" {
  depends_on = ["kubernetes_namespace.gloo_namespace"]

  triggers {
    manifest_sha1 = "${sha1(data.template_file.proxy_resource.rendered)}"
  }

  provisioner "local-exec" {
    command = "${var.kubeconfig_file_path != "" ? format(
      "export KUBECONFIG=%s && kubectl apply -f -<<EOF\n%s\nEOF",
      var.kubeconfig_file_path,
      data.template_file.proxy_resource.rendered
    ) : format(
      "kubectl apply -f -<<EOF\n%s\nEOF",
      data.template_file.proxy_resource.rendered
    )}"
  }
}

resource "null_resource" "settings_resource" {
  depends_on = ["kubernetes_namespace.gloo_namespace"]

  triggers {
    manifest_sha1 = "${sha1(data.template_file.settings_resource.rendered)}"
  }

  provisioner "local-exec" {
    command = "${var.kubeconfig_file_path != "" ? format(
      "export KUBECONFIG=%s && kubectl apply -f -<<EOF\n%s\nEOF",
      var.kubeconfig_file_path,
      data.template_file.settings_resource.rendered
    ) : format(
      "kubectl apply -f -<<EOF\n%s\nEOF",
      data.template_file.settings_resource.rendered
    )}"
  }
}

resource "null_resource" "upstreams_resource" {
  depends_on = ["kubernetes_namespace.gloo_namespace"]

  triggers {
    manifest_sha1 = "${sha1(data.template_file.upstreams_resource.rendered)}"
  }

  provisioner "local-exec" {
    command = "${var.kubeconfig_file_path != "" ? format(
      "export KUBECONFIG=%s && kubectl apply -f -<<EOF\n%s\nEOF",
      var.kubeconfig_file_path,
      data.template_file.upstreams_resource.rendered
    ) : format(
      "kubectl apply -f -<<EOF\n%s\nEOF",
      data.template_file.upstreams_resource.rendered
    )}"
  }
}

resource "null_resource" "upstream_groups_resource" {
  depends_on = ["kubernetes_namespace.gloo_namespace"]

  triggers {
    manifest_sha1 = "${sha1(data.template_file.upstream_groups_resource.rendered)}"
  }

  provisioner "local-exec" {
    command = "${var.kubeconfig_file_path != "" ? format(
      "export KUBECONFIG=%s && kubectl apply -f -<<EOF\n%s\nEOF",
      var.kubeconfig_file_path,
      data.template_file.upstream_groups_resource.rendered
    ) : format(
      "kubectl apply -f -<<EOF\n%s\nEOF",
      data.template_file.upstream_groups_resource.rendered
    )}"
  }
}

resource "null_resource" "virtual_services_resource" {
  depends_on = ["kubernetes_namespace.gloo_namespace"]

  triggers {
    manifest_sha1 = "${sha1(data.template_file.virtual_services_resource.rendered)}"
  }

  provisioner "local-exec" {
    command = "${var.kubeconfig_file_path != "" ? format(
      "export KUBECONFIG=%s && kubectl apply -f -<<EOF\n%s\nEOF",
      var.kubeconfig_file_path,
      data.template_file.virtual_services_resource.rendered
    ) : format(
      "kubectl apply -f -<<EOF\n%s\nEOF",
      data.template_file.virtual_services_resource.rendered
    )}"
  }
}
