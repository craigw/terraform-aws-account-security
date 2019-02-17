resource "aws_guardduty_detector" "account" {
  provider = "aws.account-security"
  enable   = "${var.guardduty_enabled}"
}
