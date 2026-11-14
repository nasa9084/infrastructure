// The only member of the account is its owner, so notifications go to that
// address. Marked sensitive so that it does not appear in the plan comments of
// this public repository.
data "cloudflare_account_members" "this" {
  account_id = cloudflare_zone.web_apps_tech.account.id
  status     = "accepted"
}

locals {
  account_owner_email = sensitive(one(data.cloudflare_account_members.this.result).email)
}

import {
  id = "abe0a185132e745748442fe5611bfff7/6c63247b28de417db9fce40cf9fcecec"
  to = cloudflare_notification_policy.passive_origin_monitoring
}

resource "cloudflare_notification_policy" "passive_origin_monitoring" {
  account_id = cloudflare_zone.web_apps_tech.account.id

  name        = "Passive Origin Monitoring"
  description = "Recieve an email when your origin becomes unreachable"
  enabled     = true
  alert_type  = "real_origin_monitoring"

  mechanisms = {
    email = [{ id = local.account_owner_email }]
  }
}
