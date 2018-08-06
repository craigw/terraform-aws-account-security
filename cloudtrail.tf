resource "aws_iam_role" "cloudtrail-to-cloudwatch" {
  provider = "aws.account-security"
  name     = "CloudTrailToCloudWatch"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloudtrail-to-cloudwatch" {
  provider = "aws.account-security"
  name     = "CloudTrailToCloudWatch"
  role     = "${aws_iam_role.cloudtrail-to-cloudwatch.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["logs:CreateLogStream"],
      "Resource": [
        "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${aws_cloudwatch_log_group.cloudtrail.id}:log-stream:*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": ["logs:PutLogEvents"],
      "Resource": [
        "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${aws_cloudwatch_log_group.cloudtrail.id}:log-stream:*"
      ]
    }
  ]
}
EOF
}

resource "aws_cloudwatch_log_group" "cloudtrail" {
  provider = "aws.account-security"
  name     = "account-cloudtrail"

  retention_in_days = 7

  tags {
    Name         = "${var.organisation}-${var.application}-${var.environment}-log-group"
    Organisation = "${var.organisation}"
    Project      = "${var.application}"
    Comment      = "Managed by Terraform"
    Environment  = "${var.environment}"
  }
}

resource "aws_cloudtrail" "account" {
  provider                      = "aws.account-security"
  s3_bucket_name                = "${var.cloudwatch_bucket_name}"
  s3_key_prefix                 = "cloudtrail/${var.organisation}/${var.application}/${var.environment}"
  name                          = "${var.organisation}-${var.application}-${var.environment}-ct"
  enable_logging                = true
  include_global_service_events = true
  is_multi_region_trail         = true

  # https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-log-file-validation-intro.html
  enable_log_file_validation = true
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail.arn}"
  cloud_watch_logs_role_arn  = "${aws_iam_role.cloudtrail-to-cloudwatch.arn}"

  tags {
    Name         = "${var.organisation}-${var.application}-${var.environment}-ct"
    Organisation = "${var.organisation}"
    Project      = "${var.application}"
    Comment      = "Managed by Terraform"
    Environment  = "${var.environment}"
  }
}
