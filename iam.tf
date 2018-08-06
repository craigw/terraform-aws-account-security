locals {
  account_alias = "${var.account_alias == "" ? "${var.organisation}-${var.application}-${var.environment}" : var.account_alias}"
}

resource "aws_iam_account_alias" "alias" {
  provider   = "aws.account-security"
  account_alias = "${local.account_alias}"
}
