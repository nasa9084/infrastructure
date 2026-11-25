// Set as workspace variables in Terraform Cloud (cloudflare workspace).

variable "google_oauth_client_id" {
  description = "OAuth client ID of the Google Cloud OAuth client used by the Access Google login method"
  type        = string
}

variable "google_oauth_client_secret" {
  description = "OAuth client secret of the Google Cloud OAuth client used by the Access Google login method"
  type        = string
  sensitive   = true
}

// HCL variable, e.g. ["someone@example.com"]. Sensitive so that the addresses
// do not appear in the plan comments of this public repository.
variable "access_allowed_emails" {
  description = "Email addresses allowed by the reusable Access policy \"Email\""
  type        = list(string)
  sensitive   = true
}

// HCL variable: the owner's and the family members' addresses. Sensitive for
// the same reason as access_allowed_emails.
variable "hondana_allowed_emails" {
  description = "Email addresses that may sign in to hondana.web-apps.tech (kkids-sync)"
  type        = list(string)
  sensitive   = true
}
