terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

provider "docker" {}

# Dynamic input
variable "container_config" {
  default = [
    {
      name = "web1"
      port = 8081
    },
    {
      name = "web2"
      port = 8082
    },
    {
      name = "web3"
      port = 8083
    }
  ]
}

# Convert list → map for for_each
locals {
  container_map = {
    for c in var.container_config :
    c.name => c
  }
}

# Dynamic module creation
module "containers" {
  for_each = local.container_map

  source = "./modules/nginx_container"

  container_name = each.value.name
  container_port = each.value.port
  image_name     = "nginx:latest"
}

output "container_urls" {
  value = [
    for c in var.container_config :
    "http://localhost:${c.port}"
  ]
}