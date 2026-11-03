// MCP server portal: one OAuth-protected endpoint (https://mcp.web-apps.tech/mcp)
// for the claude.ai connectors (web / mobile). Access acts as the OAuth
// authorization server (managed OAuth + DCR), so the MCP servers themselves
// need no OAuth.
//
//   Claude --OAuth--> portal --service token--> Access app of each server --> tunnel k8s --> Service
//
// To add a server: Service + ingress in tunnel.tf, a self_hosted Access app that
// includes cloudflare_zero_trust_access_policy.mcp_portal_upstream, then an
// entry in local.mcp_servers.

locals {
  mcp_servers = {
    proxmox = {
      name     = "Proxmox"
      hostname = "https://mcp-proxmox.web-apps.tech/mcp"
    }
  }

  // Claude's OAuth callback; claude.com may replace claude.ai in the future.
  claude_oauth_callbacks = [
    "https://claude.ai/api/mcp/auth_callback",
    "https://claude.com/api/mcp/auth_callback",
  ]
}

resource "cloudflare_zero_trust_access_ai_controls_mcp_server" "this" {
  for_each = local.mcp_servers

  account_id = cloudflare_zone.web_apps_tech.account.id

  id        = each.key
  name      = each.value.name
  hostname  = each.value.hostname
  auth_type = "bearer"
  auth_credentials = jsonencode({
    headers = {
      "cf-access-client-id"     = cloudflare_zero_trust_access_service_token.mcp_portal.client_id
      "cf-access-client-secret" = cloudflare_zero_trust_access_service_token.mcp_portal.client_secret
    }
  })

  // Cloudflare connects to the server on create to sync its tools, so the
  // upstream Access app must already accept the portal's service token.
  depends_on = [
    cloudflare_zero_trust_access_application.mcp_proxmox,
    cloudflare_zero_trust_tunnel_cloudflared_config.k8s,
  ]
}

// Who can see each server in the portal.
resource "cloudflare_zero_trust_access_application" "mcp_server" {
  for_each = local.mcp_servers

  account_id = cloudflare_zone.web_apps_tech.account.id

  name = "mcp-server-${each.key}"
  type = "mcp"

  destinations = [
    {
      type          = "via_mcp_server_portal"
      mcp_server_id = cloudflare_zero_trust_access_ai_controls_mcp_server.this[each.key].id
    },
  ]

  policies = [
    { id = cloudflare_zero_trust_access_policy.email.id, precedence = 1 },
  ]
}

// Provider 5.28.1 plans on_behalf = true (its default) on every in-place update of
// `servers`, even when false is set; only create honors the configured value. With true,
// the portal requires a per-user grant for the server and its tools disappear for Google
// login sessions. So in-place updates of `servers` are ignored, and a change in the server
// list recreates the portal instead (the portal's Access app and its OAuth sessions stay).
resource "terraform_data" "mcp_portal_servers" {
  input = {
    servers = sort(keys(local.mcp_servers))
    // Bump to force the portal to be recreated (e.g. to reset on_behalf after an in-place update).
    generation = 1
  }
}

resource "cloudflare_zero_trust_access_ai_controls_mcp_portal" "home" {
  account_id = cloudflare_zone.web_apps_tech.account.id

  id       = "home"
  name     = "Home"
  hostname = "mcp.web-apps.tech"

  servers = [
    for id, _ in local.mcp_servers : {
      server_id = cloudflare_zero_trust_access_ai_controls_mcp_server.this[id].id
      on_behalf = false // use the portal's credential (bearer) for every user
    }
  ]

  lifecycle {
    ignore_changes       = [servers]
    replace_triggered_by = [terraform_data.mcp_portal_servers]
  }
}

resource "cloudflare_zero_trust_access_application" "mcp_portal" {
  account_id = cloudflare_zone.web_apps_tech.account.id

  name   = "mcp-portal"
  type   = "mcp_portal"
  domain = cloudflare_zero_trust_access_ai_controls_mcp_portal.home.hostname

  destinations = [
    { type = "public", uri = cloudflare_zero_trust_access_ai_controls_mcp_portal.home.hostname },
  ]

  allowed_idps              = [cloudflare_zero_trust_access_identity_provider.google.id]
  auto_redirect_to_identity = true

  policies = [
    { id = cloudflare_zero_trust_access_policy.email.id, precedence = 1 },
  ]

  oauth_configuration = {
    enabled = true
    dynamic_client_registration = {
      enabled                = true
      allowed_uris           = local.claude_oauth_callbacks
      allow_any_on_localhost = true // Claude Code
      allow_any_on_loopback  = true
    }
    grant = {
      access_token_lifetime = "15m"
      session_duration      = "336h" // re-login on the phone every two weeks
    }
  }
}
