resource "cloudflare_page_rule" "root" {
  zone_id  = data.cloudflare_zone.web_apps_tech.id
  priority = 1

  target = "web-apps.tech/*"
  actions {
    forwarding_url {
      status_code = 301
      url         = "https://blog.web-apps.tech/$1"
    }
  }
}

resource "cloudflare_page_rule" "www" {
  zone_id  = data.cloudflare_zone.web_apps_tech.id
  priority = 2

  target = "www.web-apps.tech/*"
  actions {
    forwarding_url {
      status_code = 301
      url         = "https://blog.web-apps.tech/$1"
    }
  }
}
