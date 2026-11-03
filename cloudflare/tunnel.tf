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

// Tunnel for the home k0s cluster. The connector runs as a Deployment in
// kubernetes/stacks/mcp-proxmox/cloudflared.yaml. Created in the dashboard and
// imported here so that new MCP servers can be added by Terraform.
import {
  id = "abe0a185132e745748442fe5611bfff7/b3caacbf-0de6-460b-adf9-7c764c024971"
  to = cloudflare_zero_trust_tunnel_cloudflared.k8s
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "k8s" {
  account_id = cloudflare_zone.web_apps_tech.account.id

  name       = "k8s"
  config_src = "cloudflare"
}

import {
  id = "abe0a185132e745748442fe5611bfff7/b3caacbf-0de6-460b-adf9-7c764c024971"
  to = cloudflare_zero_trust_tunnel_cloudflared_config.k8s
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "k8s" {
  account_id = cloudflare_zone.web_apps_tech.account.id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.k8s.id

  source = "cloudflare"
  config = {
    ingress = [
      {
        service  = "http://proxmox-mcp.mcp-proxmox.svc:8000"
        hostname = "mcp-proxmox.web-apps.tech"

        origin_request = {
          http_host_header = "proxmox-mcp.mcp-proxmox.svc:8000"

          // cloudflared rejects requests without a valid Access JWT for this
          // application, so the origin stays closed even if the Access app is
          // misconfigured.
          access = {
            required  = true
            team_name = "nasa9084"
            aud_tag   = [cloudflare_zero_trust_access_application.mcp_proxmox.aud]
          }
        }
      },
      {
        service  = "http://line-bot-mcp.mcp-line-bot.svc.cluster.local:8000"
        hostname = "mcp-line-bot.web-apps.tech"

        origin_request = {
          access = {
            required  = true
            team_name = "nasa9084"
            aud_tag   = [cloudflare_zero_trust_access_application.mcp_line_bot.aud]
          }
        }
      },
      {
        service  = "http://grocy-mcp.mcp-grocy.svc:8000"
        hostname = "mcp-grocy.web-apps.tech"

        origin_request = {
          http_host_header = "grocy-mcp.mcp-grocy.svc:8000"

          access = {
            required  = true
            team_name = "nasa9084"
            aud_tag   = [cloudflare_zero_trust_access_application.mcp_grocy.aud]
          }
        }
      },
      {
        service = "http_status:404"
      },
    ]
  }
}
