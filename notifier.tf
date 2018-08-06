module "notify_slack" {
  source = "github.com/barkingiguana/terraform-aws-notify-slack"

  role_arn = "${var.role_arn}"

  sns_topic_name    = "security-alerts"
  slack_webhook_url = "${var.slack_notifier_webhook_url}"
  slack_channel     = "${var.slack_notifier_channel}"
  slack_username    = "${var.slack_notifier_username}"
}
