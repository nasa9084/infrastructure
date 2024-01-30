resource "github_repository" "nasa9084_github_io" {
  name         = "nasa9084.github.io"
  description  = "resume"
  homepage_url = "https://nasa9084.github.io"

  archive_on_destroy = true

  has_issues = true

  pages {
    build_type = "legacy"
    cname      = "resume.web-apps.tech"

    source {
      branch = "master"
      path   = "/"
    }
  }
}
