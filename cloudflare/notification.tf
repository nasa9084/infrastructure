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
    email = [{ id = var.notification_email }]
  }
}
