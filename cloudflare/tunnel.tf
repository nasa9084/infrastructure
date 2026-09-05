resource "cloudflare_zero_trust_tunnel_cloudflared" "homeassistant" {
  account_id = cloudflare_zone.web_apps_tech.account.id

  name       = "homeassistant"
  config_src = "local"
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "proxmox" {
  account_id = cloudflare_zone.web_apps_tech.account.id

  name       = "proxmox"
  config_src = "cloudflare"
}

import {
  id = "abe0a185132e745748442fe5611bfff7/de18fe13-9a83-48c4-a525-5624d03bd64a"
  to = cloudflare_zero_trust_tunnel_cloudflared_config.proxmox
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "proxmox" {
  account_id = cloudflare_zone.web_apps_tech.account.id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.proxmox.id

  source = "cloudflare"
  config = {
    ingress = [
      {
        service  = "https://192.168.1.2:8006"
        hostname = "proxmox.web-apps.tech"

        origin_request = {
          no_tls_verify = true
        }
      },
      {
        service = "http_status:404"
      },
    ]
  }
}
