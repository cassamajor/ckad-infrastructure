locals {
  store_private_key = yamlencode({
    #cloud-config
    write_files = [
      {
        path        = "root/.ssh/id_rsa"
        permissions = "0600"
        owner       = "root:root"
        content     = tls_private_key.key.private_key_pem
        defer       = true
    }]
    hostname = "cp"
  })
  setWorkerHostname = yamlencode({
    #cloud-config
    hostname = "worker"
  })
}

data "cloudinit_config" "workerNode" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/config/workerNode.sh",
      {
        URL      = var.lab_solution_url,
        USER     = var.lab_solution_username,
        PASSWORD = var.lab_solution_password,
      }
    )
    filename = "workerNode.sh"
  }

  part {
    content_type = "text/cloud-config"
    content      = local.setWorkerHostname
  }
}

data "cloudinit_config" "controlPlane" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/config/controlPlane.sh",
      {
        URL         = var.lab_solution_url,
        USER        = var.lab_solution_username,
        PASSWORD    = var.lab_solution_password,
        WORKER_NODE = module.worker_node.private_ip,
      }
    )
    filename = "controlPlane.sh"
  }

  dynamic "part" {
    for_each = var.enable_registry ? [1] : []
    content {
      content_type = "text/x-shellscript"
      content = templatefile("${path.module}/config/registry.sh",
        {
          WORKER_NODE = module.worker_node.private_ip,
        }
      )
      filename = "registry.sh"
    }
  }

  part {
    content_type = "text/cloud-config"
    content      = local.store_private_key
  }
}
