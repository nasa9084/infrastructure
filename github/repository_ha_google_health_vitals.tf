import {
  id = "ha-google-health-vitals"
  to = github_repository.ha_google_health_vitals
}

resource "github_repository" "ha_google_health_vitals" {
  name = "ha-google-health-vitals"

  # only allow squash merge
  allow_merge_commit = false
  allow_rebase_merge = false

  archive_on_destroy     = true
  delete_branch_on_merge = true

  has_issues = true
}
