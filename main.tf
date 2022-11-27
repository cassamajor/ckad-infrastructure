provider "aws" {
  region  = var.region
  profile = var.profile
}

# Network Requirements:
  # - Don’t use 192.168 network for nodes
  # - No firewall

# System Requirements
  # - 2 CPU
  # - 8G memory
  # - 20G+ disk on control plane node
  # - Disable swap
  # - Disable SELinux and AppArmor

module "infrastructure" {
  source = "./modules/infrastructure"
}

module "worker_node" {
  source = "./modules/ec2"

  aws_key_pair        = aws_key_pair.key.id
  aws_security_groups = [module.infrastructure.security_group_id]
  aws_subnet_id       = module.infrastructure.subnet_id
  cloudinit_config    = data.cloudinit_config.workerNode.rendered

  tags = {
    Name = "workerNode"
  }
}

module "control_plane" {
  source = "./modules/ec2"

  aws_key_pair        = aws_key_pair.key.id
  aws_security_groups = [module.infrastructure.security_group_id]
  aws_subnet_id       = module.infrastructure.subnet_id
  cloudinit_config    = data.cloudinit_config.controlPlane.rendered

  tags = {
    Name = "controlPlane"
  }

  depends_on = [module.worker_node]
}
