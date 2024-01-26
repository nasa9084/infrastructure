resource "github_repository" "infrastructure" {
  name = "infrastructure"

  # only allow squash merge
  allow_merge_commit = false
  allow_rebase_merge = false

  delete_branch_on_merge = true
  archive_on_destroy     = true
}
