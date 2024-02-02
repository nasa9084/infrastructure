import {
  to = github_repository.gmail_resource
  id = "gmail-resource"
}

resource "github_repository" "gmail_resource" {
  name       = "gmail-resource"
  visibility = "private"
}
