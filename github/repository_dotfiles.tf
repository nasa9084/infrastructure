resource "github_repository" "dotfiles" {
  name   = "dotfiles"
  topics = ["dotfiles"]
}


resource "github_repository" "dotfiles_secret" {
  name       = "dotfiles-secret"
  visibility = "private"
}
