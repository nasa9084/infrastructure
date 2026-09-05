import {
  id = "abe0a185132e745748442fe5611bfff7/ffe39430-be39-4b90-a522-08cf5534a0cd"
  to = cloudflare_zero_trust_tunnel_cloudflared.homeassistant
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "homeassistant" {
  account_id = cloudflare_zone.web_apps_tech.account.id

  name = "homeassistant"
  config_src = "cloudflare"
}

import {
  id = "abe0a185132e745748442fe5611bfff7/de18fe13-9a83-48c4-a525-5624d03bd64a"
  to = cloudflare_zero_trust_tunnel_cloudflared.proxmox
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "proxmox" {
  account_id = cloudflare_zone.web_apps_tech.account.id

  name = "proxmox"
  config_src = "cloudflare"
}
