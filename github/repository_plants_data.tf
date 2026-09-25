# Data for the plant management iOS app. The app commits to main directly.
resource "github_repository" "plants_data" {
  name        = "plants-data"
  description = "Plant records for my plant management iOS app"
  visibility  = "private"

  allow_merge_commit = false
  allow_rebase_merge = false

  archive_on_destroy     = true
  delete_branch_on_merge = true

  has_issues = true
}
