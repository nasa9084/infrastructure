terraform {
  required_version = "~> 1.15.0"

  cloud {
    organization = "nasa9084"

    workspaces {
      name = "cloudflare"
    }
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.19.1"
    }
  }
}

provider "cloudflare" {}
