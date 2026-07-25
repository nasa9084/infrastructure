resource "github_repository" "home-assistant-config" {
  name = "home-assistant-config"

  allow_merge_commit = false
  allow_rebase_merge = false

  archive_on_destroy = true
  delete_branch_on_merge = true

  has_issues = true
}
