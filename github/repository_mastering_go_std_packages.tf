resource "github_repository" "mastering_go_std_packages" {
  name       = "mastering-go-std-packages"
  visibility = "private"

  template {
    include_all_branches = false
    owner                = "TechBooster"
    repository           = "ReVIEW-Template"
  }
}

resource "github_repository" "mastering_go_std_packages_2" {
  name       = "mastering-go-std-packages-2"
  visibility = "private"

  template {
    include_all_branches = false
    owner                = "TechBooster"
    repository           = "ReVIEW-Template"
  }
}
