// //////////////////////////////
// zone
// //////////////////////////////

resource "cloudflare_zone" "web_apps_tech" {
  name = "web-apps.tech"
  account = {
    id = "abe0a185132e745748442fe5611bfff7"
  }
}

resource "cloudflare_zone_dnssec" "web_apps_tech" {
  zone_id = cloudflare_zone.web_apps_tech.id

  status = "active"
}

// //////////////////////////////
// A records
// //////////////////////////////

resource "cloudflare_dns_record" "a_web_apps_tech" {
  zone_id = cloudflare_zone.web_apps_tech.id

  name    = "web-apps.tech"
  type    = "A"
  content = "192.0.2.1"

  comment = "page rule"

  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "a_www" {
  zone_id = cloudflare_zone.web_apps_tech.id

  name    = "www"
  type    = "A"
  content = "192.0.2.1"

  comment = "page rule"

  proxied = true
  ttl     = 1
}

// //////////////////////////////
// CNAME records
// //////////////////////////////

resource "cloudflare_dns_record" "cname_blog" {
  zone_id = cloudflare_zone.web_apps_tech.id

  name    = "blog"
  type    = "CNAME"
  content = "nasa9084.github.io"
  ttl     = 60
}

resource "cloudflare_dns_record" "cname_resume" {
  zone_id = cloudflare_zone.web_apps_tech.id

  name    = "resume"
  type    = "CNAME"
  content = "nasa9084.github.io"
  ttl     = 120
}

// //////////////////////////////
// Tunnel records
// //////////////////////////////

resource "cloudflare_dns_record" "hass" {
  zone_id = cloudflare_zone.web_apps_tech.id

  name    = "hass"
  type    = "CNAME"
  content = "${cloudflare_zero_trust_tunnel_cloudflared.homeassistant.id}.cfargotunnel.com"
  ttl     = 1
  proxied = true
}


resource "cloudflare_dns_record" "proxmox" {
  zone_id = cloudflare_zone.web_apps_tech.id

  name    = "proxmox"
  type    = "CNAME"
  content = "${cloudflare_zero_trust_tunnel_cloudflared.proxmox.id}.cfargotunnel.com"
  ttl     = 1
  proxied = true
}

import {
  id = "08db5577586403ed45dd2981644cb873/8722adb1e0301913d5d15084a1764ceb"
  to = cloudflare_dns_record.mcp_proxmox
}

resource "cloudflare_dns_record" "mcp_proxmox" {
  zone_id = cloudflare_zone.web_apps_tech.id

  name    = "mcp-proxmox"
  type    = "CNAME"
  content = "${cloudflare_zero_trust_tunnel_cloudflared.k8s.id}.cfargotunnel.com"
  ttl     = 1
  proxied = true
}

import {
  id = "08db5577586403ed45dd2981644cb873/091f8d901cee84c1172e8e0510585cd0"
  to = cloudflare_dns_record.mcp_line_bot
}

// moved from the dashboard-made tunnel "mcp-line-bot" to the k8s tunnel
resource "cloudflare_dns_record" "mcp_line_bot" {
  zone_id = cloudflare_zone.web_apps_tech.id

  name    = "mcp-line-bot"
  type    = "CNAME"
  content = "${cloudflare_zero_trust_tunnel_cloudflared.k8s.id}.cfargotunnel.com"
  ttl     = 1
  proxied = true
}

// MCP server portal (see mcp_portal.tf). Terraform does not create this record
// for the portal; without it the portal returns 522.
resource "cloudflare_dns_record" "mcp" {
  zone_id = cloudflare_zone.web_apps_tech.id

  name    = "mcp"
  type    = "CNAME"
  content = "gateway.agents.cloudflare.com"
  ttl     = 1
  proxied = true
}

// //////////////////////////////
// TXT records
// //////////////////////////////

resource "cloudflare_dns_record" "txt_github_pages_challenge_blog" {
  zone_id = cloudflare_zone.web_apps_tech.id

  name    = "_github-pages-challenge-nasa9084.blog"
  type    = "TXT"
  content = "e5c680fe236c23a6f63234549cb274"
  ttl     = 1
}

resource "cloudflare_dns_record" "txt_dmarc" {
  zone_id = cloudflare_zone.web_apps_tech.id

  name    = "_dmarc"
  type    = "TXT"
  content = "\"v=DMARC1;  p=none; rua=mailto:4725826b8ac34b6ebdfd417ab2ce571c@dmarc-reports.cloudflare.net\""
  ttl     = 1
}

resource "cloudflare_dns_record" "_gh_web_apps_tech_o" {
  zone_id = cloudflare_zone.web_apps_tech.id

  name    = "_gh-web-apps-tech-o"
  type    = "TXT"
  content = "078b0c07f9"
  ttl     = 1
}
