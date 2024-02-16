import {
  to = cloudflare_page_rule.root
  id = "08db5577586403ed45dd2981644cb873/4313b516b3533bffe627036897de17be"
}

import {
  to = cloudflare_page_rule.www
  id = "08db5577586403ed45dd2981644cb873/6e69c393c72e8dd0e16a99f5c4c4d751"
}

resource "cloudflare_page_rule" "root" {
  zone_id = data.cloudflare_zone.web_apps_tech.id
  priority = 1

  target   = "web-apps.tech/*"
  actions {
    forwarding_url {
      status_code = 301
      url         = "https://blog.web-apps.tech/$1"
    }
  }
}

resource "cloudflare_page_rule" "www" {
  zone_id = data.cloudflare_zone.web_apps_tech.id
  priority = 2

  target   = "www.web-apps.tech/*"
  actions {
    forwarding_url {
      status_code = 301
      url         = "https://blog.web-apps.tech/$1"
    }
  }
}
