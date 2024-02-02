import {
  to = github_repository.dotfiles
  id = "dotfile"
}

import {
  to = github_repository.dotfiles_secret
  id = "dotfiles-secret"
}

resource "github_repository" "dotfiles" {
  name = "dotfiles"
}


resource "github_repository" "dotfiles_secret" {
  name = "dotfiles-secret"
}
