terraform {
  required_version = "~> 1.11.0"

  cloud {
    organization = "nasa9084"

    workspaces {
      name = "cloudflare"
    }
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

provider "cloudflare" {}
