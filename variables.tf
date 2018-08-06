variable "organisation" {}
variable "application" {}
variable "environment" {}
variable "role_arn" {}
variable "cloudwatch_bucket_name" {}

variable "account_alias" {
  default = ""
}

variable "region" {
  default = "eu-west-1"
}

variable "ops_principals" {
  type = "list"

  default = []
}

variable "slack_notifier_webhook_url" {}

variable "slack_notifier_channel" {
  default = "security"
}

variable "slack_notifier_username" {
  default = "AWS"
}
