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
