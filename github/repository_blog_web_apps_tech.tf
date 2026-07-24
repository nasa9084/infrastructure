resource "github_repository" "blog_web_apps_tech" {
  name = "blog.web-apps.tech"

  # only allow squash merge
  allow_merge_commit = false
  allow_rebase_merge = false

  archive_on_destroy     = true
  delete_branch_on_merge = true

  has_issues = true
}

import {
  id = "blog.web-apps.tech"
  to = github_repository_pages.blog_web_apps_tech
}

resource "github_repository_pages" "blog_web_apps_tech" {
  repository = github_repository.blog_web_apps_tech.name

  build_type = "workflow"
  cname      = "blog.web-apps.tech"

  https_enforced = true
}
