locals {
  me = "nasa9084"
}

terraform {
  required_version = "= 1.7.1"

  cloud {
    organization = local.me
    workspaces {
      name = "github"
    }
  }

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

provider "github" {
  owner = local.me
  app_auth {} # defined on Terraform Cloud
}
