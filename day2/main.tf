terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

provider "local" {}

resource "local_file" "env_file" {
  filename = var.filename
  content  = var.message
}