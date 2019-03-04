provider "null" {}

data "template_file" "gloo_settings" {
  template = "${file("${path.module}/settings.yml.tpl")}"

  vars {
    NAMESPACE = "${var.namespace}"
    GLOO_DEPLOYMENT_XDS_PORT = "${var.xds_port}"
  }
}

data "template_file" "gloo_crd_settings" {
  template = "${file("${path.module}/settings-crd.yml.tpl")}"
}

resource "null_resource" "gloo_settings" {
  triggers {
    manifest_sha1 = "${sha1(data.template_file.gloo_settings.rendered)}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f -<<EOF\n${data.template_file.gloo_settings.rendered}\nEOF"
  }
}

resource "null_resource" "gloo_crd_settings" {
  triggers {
    manifest_sha1 = "${sha1(data.template_file.gloo_crd_settings.rendered)}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f -<<EOF\n${data.template_file.gloo_crd_settings.rendered}\nEOF"
  }
}
