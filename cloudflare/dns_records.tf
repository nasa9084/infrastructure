import {
  to = cloudflare_zone.web_apps_tech
  id = "08db5577586403ed45dd2981644cb873"
}

import {
  to = cloudflare_record.a_web_apps_tech
  id = "08db5577586403ed45dd2981644cb873/ebe0222d4aa5a83fe2aa5e459b84b8a1"
}

import {
  to = cloudflare_record.a_www
  id = "08db5577586403ed45dd2981644cb873/ec038274f96ed2b1cf368027b013af72"
}

import {
  to = cloudflare_record.cname_blog
  id = "08db5577586403ed45dd2981644cb873/5f0b8aebce4aeb0637a18a902c77d31f"
}

import {
  to = cloudflare_record.cname_resume
  id = "08db5577586403ed45dd2981644cb873/497bdf5dbfd68b6ab1a50392e2d54e26"
}

import {
  to = cloudflare_record.mx_web_apps_tech_1
  id = "08db5577586403ed45dd2981644cb873/2e8e086b83be57940e62e09ca9ca9f98"
}

import {
  to = cloudflare_record.mx_web_apps_tech_2
  id = "08db5577586403ed45dd2981644cb873/9837fba3306070023c7bbed9ffd26150"
}

import {
  to = cloudflare_record.mx_web_apps_tech_3
  id = "08db5577586403ed45dd2981644cb873/28a1a3fdd1e0ae98df92f39c9c23e3e5"
}

import {
  to = cloudflare_record.txt_web_apps_tech
  id = "08db5577586403ed45dd2981644cb873/b640595619d7a86f07bfb4415f821d5e"
}

import {
  to = cloudflare_record.txt_github_pages_challenge_blog
  id = "08db5577586403ed45dd2981644cb873/4db83ed5904e1b977a7809b123949c67"
}

import {
  to = cloudflare_record.txt_dmarc
  id = "08db5577586403ed45dd2981644cb873/976623b7d808a16e37a8b4e88ff706ee"
}

import {
  to = cloudflare_zone_dnssec.web_apps_tech
  id = "08db5577586403ed45dd2981644cb873"
}

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
  name = "web-apps.tech"
}

resource "cloudflare_zone_dnssec" "web_apps_tech" {
  zone_id = data.cloudflare_zone.web_apps_tech.id
}

// //////////////////////////////
// A records
// //////////////////////////////

resource "cloudflare_record" "a_web_apps_tech" {
  zone_id = data.cloudflare_zone.web_apps_tech.id

  name = "web-apps.tech"
  type = "A"
  value = "192.0.2.1"

  comment = "page rule"

  proxied = true
}

resource "cloudflare_record" "a_www" {
  zone_id = data.cloudflare_zone.web_apps_tech.id

  name = "www"
  type = "A"
  value = "192.0.2.1"

  comment = "page rule"

  proxied = true
}

// //////////////////////////////
// CNAME records
// //////////////////////////////

resource "cloudflare_record" "cname_blog" {
  zone_id = data.cloudflare_zone.web_apps_tech.id

  name = "blog"
  type = "CNAME"
  value = "nasa9084.github.io"
  ttl = 60
}

resource "cloudflare_record" "cname_resume" {
  zone_id = data.cloudflare_zone.web_apps_tech.id

  name = "resume"
  type = "CNAME"
  value = "nasa9084.github.io"
  ttl = 120
}

// //////////////////////////////
// MX records
// //////////////////////////////

resource "cloudflare_record" "mx_web_apps_tech_1" {
  zone_id = data.cloudflare_zone.web_apps_tech.id

  name = "web-apps.tech"
  type = "MX"
  value = "route1.mx.cloudflare.net"
  ttl = 1
  priority = 90
}


resource "cloudflare_record" "mx_web_apps_tech_2" {
  zone_id = data.cloudflare_zone.web_apps_tech.id

  name = "web-apps.tech"
  type = "MX"
  value = "route2.mx.cloudflare.net"
  ttl = 1
  priority = 50
}


resource "cloudflare_record" "mx_web_apps_tech_3" {
  zone_id = data.cloudflare_zone.web_apps_tech.id

  name = "web-apps.tech"
  type = "MX"
  value = "route3.mx.cloudflare.net"
  ttl = 1
  priority = 31
}

// //////////////////////////////
// TXT records
// //////////////////////////////

resource "cloudflare_record" "txt_github_pages_challenge_blog" {
  zone_id = data.cloudflare_zone.web_apps_tech.id

  name = "_github-pages-challenge-nasa9084.blog"
  type = "TXT"
  value = "e5c680fe236c23a6f63234549cb274"
  ttl = 1
}

resource "cloudflare_record" "txt_web_apps_tech" {
  zone_id = data.cloudflare_zone.web_apps_tech.id

  name = "web-apps.tech"
  type = "TXT"
  value = "\"v=spf1 include:_spf.mx.cloudflare.net ~all\""
  ttl = 1
}

resource "cloudflare_record" "txt_dmarc" {
  zone_id = data.cloudflare_zone.web_apps_tech.id

  name = "_dmarc"
  type = "TXT"
  value = "\"v=DMARC1;  p=none; rua=mailto:4725826b8ac34b6ebdfd417ab2ce571c@dmarc-reports.cloudflare.net\""
  ttl = 1
}
