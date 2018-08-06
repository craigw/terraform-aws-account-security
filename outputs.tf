output "account_id" {
  value = "${data.aws_caller_identity.current.account_id}"
}

output "cloudtrail_arn" {
  value = "${aws_cloudtrail.account.arn}"
}

output "security_sns_topic_arn" {
  value = "${module.slack_notifier.this_slack_topic_arn}"
}
