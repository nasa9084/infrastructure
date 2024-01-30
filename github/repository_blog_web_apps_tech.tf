resource "github_repository" "blog_web_apps_tech" {
  name = "blog.web-apps.tech"

  # only allow squash merge
  allow_merge_commit = false
  allow_rebase_merge = false

  archive_on_destroy     = true
  delete_branch_on_merge = true

  has_issues = true

  pages {
    build_type = "workflow"
    cname      = "blog.web-apps.tech"

    # source block is required / always shown as changes
    # even if I'm using GitHub Actions type build
    source {
      branch = "gh-pages"
      path = "/"
    }
  }
}
