terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.26"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.2"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.2"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 3.3"
    }
  }

  required_version = ">= 1.3.3"
}