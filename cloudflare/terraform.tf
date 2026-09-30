terraform {
  required_version = "~> 1.16.0"

  cloud {
    organization = "nasa9084"

    workspaces {
      name = "cloudflare"
    }
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.26.0"
    }
  }
}

provider "cloudflare" {}
