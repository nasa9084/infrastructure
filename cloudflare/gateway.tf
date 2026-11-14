// Default Gateway policies created by Cloudflare when Zero Trust was set up.
// Imported as they are so that they are no longer managed only in the dashboard.

resource "cloudflare_zero_trust_gateway_policy" "do_not_inspect" {
  account_id = cloudflare_zone.web_apps_tech.account.id

  name        = "Do Not Inspect"
  description = "This policy excludes from inspection applications which are known to have desktop apps with certificate pinning, and other similar conditions which cannot support inspection. There may be applications in this list which you choose to remove over time."
  precedence  = 0
  enabled     = true
  action      = "off"
  filters     = ["http"]
  traffic     = "any(app.type.ids[*] in {16})"
}

resource "cloudflare_zero_trust_gateway_policy" "default_deny_private" {
  account_id = cloudflare_zone.web_apps_tech.account.id

  name        = "Default deny for private traffic"
  description = "A catch-all policy to block all private traffic destined for the RFC1918 address space. This is meant to be your lowest-precedence network policy, which enables you to build allow policies and Access Applications to grant users access to applications and services on your private network. It also includes the default assignment range for Cloudflare One client devices in the CGNat space."
  precedence  = 10000
  enabled     = false
  action      = "block"
  filters     = ["l4"]
  traffic     = "net.dst.ip in {10.0.0.0/8 172.16.0.0/12 192.168.0.0/16 100.96.0.0/12}"

  rule_settings = {
    notification_settings = {
      enabled = true
      msg     = "This connection has been blocked by your account default-deny network policy."
    }
  }
}
