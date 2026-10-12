// long-term backup of VictoriaMetrics (vmbackup) running on the home k0s cluster
resource "cloudflare_r2_bucket" "prometheus_remote_store" {
  account_id = cloudflare_zone.web_apps_tech.account.id

  name          = "prometheus-remote-store"
  location      = "apac"
  storage_class = "Standard"
}
