terraform {
  required_version = "~> 1.7.3"

  cloud {
    organization = "nasa9084"

    workspaces {
      name = "github"
    }
  }

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

provider "github" {
  owner = "nasa9084"

  app_auth {} # defined on Terraform Cloud
}
