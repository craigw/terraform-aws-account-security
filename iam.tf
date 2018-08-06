resource "aws_iam_role" "ops" {
  provider = "aws.account-security"
  name     = "Ops"

  assume_role_policy = "${data.aws_iam_policy_document.ops.json}"
}

data "aws_iam_policy_document" "ops" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["${var.ops_principals}"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ops-role-has-administrator-policy" {
  provider   = "aws.account-security"
  role       = "${aws_iam_role.ops.id}"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

locals {
  account_alias = "${var.account_alias == "" ? "${var.organisation}-${var.application}-${var.environment}" : var.account_alias}"
}

resource "aws_iam_account_alias" "alias" {
  account_alias = "${local.account_alias}"
}
