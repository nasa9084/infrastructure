resource "github_repository" "go_switchbot" {
  name        = "go-switchbot"
  description = "SwitchBot API Client for Go"
  topics      = ["switchbot", "switchbot-api"]

  has_issues = true

  delete_branch_on_merge = true
  allow_merge_commit     = false
  allow_rebase_merge     = false
}
