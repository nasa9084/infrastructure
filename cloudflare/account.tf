/*import {
  id = "abe0a185132e745748442fe5611bfff7"
  to = cloudflare_account.nasa9084
}

resource "cloudflare_account" "nasa9084" {
  name = "nasa9084"
}
*/


data "cloudflare_zone" "web_apps_tech" {
  zone_id = cloudflare_zone.web_apps_tech.id
}

locals {
  v = data.cloudflare_zone.web_apps_tech.zone_id
}
