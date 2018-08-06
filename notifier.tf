module "notify_slack" {
  source = "github.com/barkingiguana/terraform-aws-notify-slack"

  sns_topic_name = "${aws_sns_topic.security_alerts.name}"
  create_sns_topic = false

  role_arn = "${var.role_arn}"

  slack_webhook_url = "${var.slack_notifier_webhook_url}"
  slack_channel     = "${var.slack_notifier_channel}"
  slack_username    = "${var.slack_notifier_username}"
}
