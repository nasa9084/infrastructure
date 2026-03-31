// //////////////////////////////
// zone
// //////////////////////////////

resource "cloudflare_zone" "web_apps_tech" {
  account = {
    id = "abe0a185132e745748442fe5611bfff7"
  }

  name = "web-apps.tech"
}

resource "cloudflare_zone_subscription" "web_apps_tech" {
  zone_id = cloudflare_zone.web_apps_tech.id
  rate_plan = {
    id = "free"
  }
}

resource "cloudflare_zone_dnssec" "web_apps_tech" {
  zone_id = cloudflare_zone.web_apps_tech.id
}

// //////////////////////////////
// A records
// //////////////////////////////

moved {
  from = cloudflare_record.a_web_apps_tech
  to   = cloudflare_dns_record.a_web_apps_tech
}

resource "cloudflare_dns_record" "a_web_apps_tech" {
  zone_id = cloudflare_zone.web_apps_tech.id

  name    = "web-apps.tech"
  type    = "A"
  content = "192.0.2.1"
  ttl     = 1 // auto

  comment = "page rule"

  proxied = true
}

moved {
  from = cloudflare_record.a_www
  to   = cloudflare_dns_record.a_www
}

resource "cloudflare_dns_record" "a_www" {
  zone_id = cloudflare_zone.web_apps_tech.id

  name    = "www"
  type    = "A"
  content = "192.0.2.1"
  ttl     = 1 // auto

  comment = "page rule"

  proxied = true
}

// //////////////////////////////
// CNAME records
// //////////////////////////////

moved {
  from = cloudflare_record.cname_blog
  to   = cloudflare_dns_record.cname_blog
}

resource "cloudflare_dns_record" "cname_blog" {
  zone_id = cloudflare_zone.web_apps_tech.id

  name    = "blog"
  type    = "CNAME"
  content = "nasa9084.github.io"
  ttl     = 60
}

moved {
  from = cloudflare_record.cname_resume
  to   = cloudflare_dns_record.cname_resume
}

resource "cloudflare_dns_record" "cname_resume" {
  zone_id = cloudflare_zone.web_apps_tech.id

  name    = "resume"
  type    = "CNAME"
  content = "nasa9084.github.io"
  ttl     = 120
}

// //////////////////////////////
// MX records
// //////////////////////////////

moved {
  from = cloudflare_record.mx_web_apps_tech_1
  to   = cloudflare_dns_record.mx_web_apps_tech_1
}

resource "cloudflare_dns_record" "mx_web_apps_tech_1" {
  zone_id = cloudflare_zone.web_apps_tech.id

  name     = "web-apps.tech"
  type     = "MX"
  content  = "route1.mx.cloudflare.net"
  ttl      = 1
  priority = 90
}

moved {
  from = cloudflare_record.mx_web_apps_tech_2
  to   = cloudflare_dns_record.mx_web_apps_tech_2
}

resource "cloudflare_dns_record" "mx_web_apps_tech_2" {
  zone_id = cloudflare_zone.web_apps_tech.id

  name     = "web-apps.tech"
  type     = "MX"
  content  = "route2.mx.cloudflare.net"
  ttl      = 1
  priority = 50
}

moved {
  from = cloudflare_record.mx_web_apps_tech_3
  to   = cloudflare_dns_record.mx_web_apps_tech_3
}

resource "cloudflare_dns_record" "mx_web_apps_tech_3" {
  zone_id = cloudflare_zone.web_apps_tech.id

  name     = "web-apps.tech"
  type     = "MX"
  content  = "route3.mx.cloudflare.net"
  ttl      = 1
  priority = 31
}

// //////////////////////////////
// TXT records
// //////////////////////////////

moved {
  from = cloudflare_record.txt_github_pages_challenge_blog
  to   = cloudflare_dns_record.txt_github_pages_challenge_blog
}

resource "cloudflare_dns_record" "txt_github_pages_challenge_blog" {
  zone_id = cloudflare_zone.web_apps_tech.id

  name    = "_github-pages-challenge-nasa9084.blog"
  type    = "TXT"
  content = "e5c680fe236c23a6f63234549cb274"
  ttl     = 1
}

moved {
  from = cloudflare_record.txt_web_apps_tech
  to   = cloudflare_dns_record.txt_web_apps_tech
}

resource "cloudflare_dns_record" "txt_web_apps_tech" {
  zone_id = cloudflare_zone.web_apps_tech.id

  name    = "web-apps.tech"
  type    = "TXT"
  content = "\"v=spf1 include:_spf.mx.cloudflare.net ~all\""
  ttl     = 1
}

moved {
  from = cloudflare_record.txt_dmarc
  to   = cloudflare_dns_record.txt_dmarc
}

resource "cloudflare_dns_record" "txt_dmarc" {
  zone_id = cloudflare_zone.web_apps_tech.id

  name    = "_dmarc"
  type    = "TXT"
  content = "\"v=DMARC1;  p=none; rua=mailto:4725826b8ac34b6ebdfd417ab2ce571c@dmarc-reports.cloudflare.net\""
  ttl     = 1
}
