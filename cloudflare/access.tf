// //////////////////////////////
// Login methods
// //////////////////////////////

// Google login for people (the portal, used from the claude.ai connectors).
// OAuth client: Google Cloud console > APIs & Services > Credentials,
// redirect URI https://nasa9084.cloudflareaccess.com/cdn-cgi/access/callback
resource "cloudflare_zero_trust_access_identity_provider" "google" {
  account_id = cloudflare_zone.web_apps_tech.account.id

  name = "Google"
  type = "google"
  config = {
    client_id     = var.google_oauth_client_id
    client_secret = var.google_oauth_client_secret
  }
}

// //////////////////////////////
// Reusable policies
// //////////////////////////////

import {
  id = "abe0a185132e745748442fe5611bfff7/88c9f82b-bb8e-4ac5-a6be-231ac0168dd2"
  to = cloudflare_zero_trust_access_policy.email
}

resource "cloudflare_zero_trust_access_policy" "email" {
  account_id = cloudflare_zone.web_apps_tech.account.id

  name     = "Email"
  decision = "allow"
  include = [
    for e in var.access_allowed_emails : { email = { email = e } }
  ]
}

import {
  id = "abe0a185132e745748442fe5611bfff7/69fdd9f8-5480-4978-bea7-a2a66fad4998"
  to = cloudflare_zero_trust_access_policy.mcp_proxmox
}

// Service token used by Claude Code / Desktop (claude-mcp-proxmox, created in
// the dashboard; the secret is kept outside Terraform).
resource "cloudflare_zero_trust_access_policy" "mcp_proxmox" {
  account_id = cloudflare_zone.web_apps_tech.account.id

  name     = "mcp-proxmox"
  decision = "non_identity"
  include = [
    { service_token = { token_id = "46ced6b4-446a-4228-bdd0-5265079ffab2" } },
  ]
}

// //////////////////////////////
// MCP upstream servers
// //////////////////////////////

// The MCP server portal sends this token to every upstream server
// (auth_type = "bearer" with custom headers in mcp_portal.tf).
// The secret is stored in the Terraform Cloud state.
resource "cloudflare_zero_trust_access_service_token" "mcp_portal" {
  account_id = cloudflare_zone.web_apps_tech.account.id

  name     = "mcp-portal-upstream"
  duration = "8760h"
}

resource "cloudflare_zero_trust_access_policy" "mcp_portal_upstream" {
  account_id = cloudflare_zone.web_apps_tech.account.id

  name     = "mcp-portal-upstream"
  decision = "non_identity"
  include = [
    { service_token = { token_id = cloudflare_zero_trust_access_service_token.mcp_portal.id } },
  ]
}

import {
  id = "accounts/abe0a185132e745748442fe5611bfff7/50f0446c-bb40-4f9b-93b6-8ee601a3ba9c"
  to = cloudflare_zero_trust_access_application.mcp_proxmox
}

resource "cloudflare_zero_trust_access_application" "mcp_proxmox" {
  account_id = cloudflare_zone.web_apps_tech.account.id

  name             = "mcp-proxmox"
  type             = "self_hosted"
  domain           = "mcp-proxmox.web-apps.tech"
  session_duration = "24h"

  destinations = [
    { type = "public", uri = "mcp-proxmox.web-apps.tech" },
  ]

  policies = [
    { id = cloudflare_zero_trust_access_policy.mcp_proxmox.id, precedence = 1 },
    { id = cloudflare_zero_trust_access_policy.mcp_portal_upstream.id, precedence = 2 },
  ]
}

// Reached only through the portal (the "LINE Bot" claude.ai connector with a fixed bearer
// is retired), so only the portal's service token is allowed.
resource "cloudflare_zero_trust_access_application" "mcp_line_bot" {
  account_id = cloudflare_zone.web_apps_tech.account.id

  name             = "mcp-line-bot"
  type             = "self_hosted"
  domain           = "mcp-line-bot.web-apps.tech"
  session_duration = "24h"

  destinations = [
    { type = "public", uri = "mcp-line-bot.web-apps.tech" },
  ]

  policies = [
    { id = cloudflare_zero_trust_access_policy.mcp_portal_upstream.id, precedence = 1 },
  ]
}
