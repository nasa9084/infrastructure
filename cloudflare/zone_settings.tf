// Zone settings changed from the default in the dashboard. Other settings are
// left at the Cloudflare defaults and are not managed here.

resource "cloudflare_zone_setting" "always_use_https" {
  zone_id    = cloudflare_zone.web_apps_tech.id
  setting_id = "always_use_https"
  value      = "on"
}

resource "cloudflare_zone_setting" "ipv6" {
  zone_id    = cloudflare_zone.web_apps_tech.id
  setting_id = "ipv6"
  value      = "on"
}

// Only the redirect-only A records and tunnels are proxied, so the edge never
// talks to an origin over plain HTTP in practice.
resource "cloudflare_zone_setting" "ssl" {
  zone_id    = cloudflare_zone.web_apps_tech.id
  setting_id = "ssl"
  value      = "flexible"
}
