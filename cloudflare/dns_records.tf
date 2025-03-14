// //////////////////////////////
// zone
// //////////////////////////////

resource "cloudflare_zone" "web_apps_tech" {
  account_id = "abe0a185132e745748442fe5611bfff7"

  zone = "web-apps.tech"
  plan = "free"
}

data "cloudflare_zone" "web_apps_tech" {
  account_id = "abe0a185132e745748442fe5611bfff7"
  name       = "web-apps.tech"
}

resource "cloudflare_zone_dnssec" "web_apps_tech" {
  zone_id = data.cloudflare_zone.web_apps_tech.id
}

// //////////////////////////////
// A records
// //////////////////////////////

resource "cloudflare_record" "a_web_apps_tech" {
  zone_id = data.cloudflare_zone.web_apps_tech.id

  name    = "web-apps.tech"
  type    = "A"
  content = "192.0.2.1"

  comment = "page rule"

  proxied = true
}

resource "cloudflare_record" "a_www" {
  zone_id = data.cloudflare_zone.web_apps_tech.id

  name    = "www"
  type    = "A"
  content = "192.0.2.1"

  comment = "page rule"

  proxied = true
}

// //////////////////////////////
// CNAME records
// //////////////////////////////

resource "cloudflare_record" "cname_blog" {
  zone_id = data.cloudflare_zone.web_apps_tech.id

  name    = "blog"
  type    = "CNAME"
  content = "nasa9084.github.io"
  ttl     = 60
}

resource "cloudflare_record" "cname_resume" {
  zone_id = data.cloudflare_zone.web_apps_tech.id

  name    = "resume"
  type    = "CNAME"
  content = "nasa9084.github.io"
  ttl     = 120
}

resource "cloudflare_record" "cname_blog" {
  zone_id = data.cloudflare_zone.web_apps_tech.id

  name    = "exporter"
  type    = "CNAME"
  content = "nasa9084.github.io"
  ttl     = 60
}


// //////////////////////////////
// MX records
// //////////////////////////////

resource "cloudflare_record" "mx_web_apps_tech_1" {
  zone_id = data.cloudflare_zone.web_apps_tech.id

  name     = "web-apps.tech"
  type     = "MX"
  content  = "route1.mx.cloudflare.net"
  ttl      = 1
  priority = 90
}


resource "cloudflare_record" "mx_web_apps_tech_2" {
  zone_id = data.cloudflare_zone.web_apps_tech.id

  name     = "web-apps.tech"
  type     = "MX"
  content  = "route2.mx.cloudflare.net"
  ttl      = 1
  priority = 50
}


resource "cloudflare_record" "mx_web_apps_tech_3" {
  zone_id = data.cloudflare_zone.web_apps_tech.id

  name     = "web-apps.tech"
  type     = "MX"
  content  = "route3.mx.cloudflare.net"
  ttl      = 1
  priority = 31
}

// //////////////////////////////
// TXT records
// //////////////////////////////

resource "cloudflare_record" "txt_github_pages_challenge_blog" {
  zone_id = data.cloudflare_zone.web_apps_tech.id

  name    = "_github-pages-challenge-nasa9084.blog"
  type    = "TXT"
  content = "e5c680fe236c23a6f63234549cb274"
  ttl     = 1
}

resource "cloudflare_record" "txt_web_apps_tech" {
  zone_id = data.cloudflare_zone.web_apps_tech.id

  name    = "web-apps.tech"
  type    = "TXT"
  content = "\"v=spf1 include:_spf.mx.cloudflare.net ~all\""
  ttl     = 1
}

resource "cloudflare_record" "txt_dmarc" {
  zone_id = data.cloudflare_zone.web_apps_tech.id

  name    = "_dmarc"
  type    = "TXT"
  content = "\"v=DMARC1;  p=none; rua=mailto:4725826b8ac34b6ebdfd417ab2ce571c@dmarc-reports.cloudflare.net\""
  ttl     = 1
}
