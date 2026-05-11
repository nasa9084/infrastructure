resource "github_repository" "nasa9084_github_io" {
  name         = "nasa9084.github.io"
  description  = "resume"
  homepage_url = "https://nasa9084.github.io"

  archive_on_destroy = true

  has_issues = true
}

import {
  id = "nasa9084.github.io"
  to = github_repository_pages.nasa9084_github_io
}

resource "github_repository_pages" "nasa9084_github_io" {
  repository = github_repository.nasa9084_github_io.name

  build_type = "legacy"
  cname      = "resume.web-apps.tech"

  source {
    branch = "master"
    path   = "/"
  }

  https_enforced = true
}
