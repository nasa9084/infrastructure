import {
  to = github_repository.mastering_go_std_packages
  id = "mastering-go-std-packages"
}

import {
  to = github_repository.mastering_go_std_packages_2
  id = "mastering-go-std-packages-2"
}

resource "github_repository" "mastering_go_std_packages" {
  name = "mastering-go-std-packages"
  visibility = "private"
}

resource "github_repository" "mastering_go_std_packages_2" {
  name = "mastering-go-std-packages-2"
  visibility = "private"
}
