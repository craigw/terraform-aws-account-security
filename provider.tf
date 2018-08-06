provider "aws" {
  alias   = "account-security"
  version = "~> 1.27"

  assume_role {
    role_arn = "${var.role_arn}"
  }

  region = "${var.region}"
}

data "aws_caller_identity" "current" {
  provider = "aws.account-security"
}
