import {
  to = github_repository.nasa9084_github_io
  id = "nasa9084.github.io"
}

resource "github_repository" "nasa9084_github_io" {
  name        = "nasa9084.github.io"
  description = "resume"

  has_issues    = true

  homepage_url = "https://nasa9084.github.io"

  pages {
    build_type = "legacy"
    cname      = "resume.web-apps.tech"

    source {
      branch = "master"
      path   = "/"
    }
  }
}
