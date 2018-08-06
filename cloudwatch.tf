locals {
  metrics_namespace = "${var.organisation}/${var.application}/${var.environment}"
  prefix            = "${var.organisation}-${var.application}-${var.environment}-"
  alarm_prefix      = "[${var.organisation}/${var.application}/${var.environment}] "
}

resource "aws_cloudwatch_log_metric_filter" "root_login" {
  provider       = "aws.account-security"
  name           = "root-access"
  pattern        = "{$.userIdentity.type = Root}"
  log_group_name = "${aws_cloudwatch_log_group.cloudtrail.name}"

  metric_transformation {
    name      = "RootAccessCount"
    namespace = "${local.metrics_namespace}"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "root_login" {
  provider            = "aws.account-security"
  alarm_name          = "root-access"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "RootAccessCount"
  namespace           = "${local.metrics_namespace}"
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "${local.alarm_prefix}Use of the root account has been detected"
  alarm_actions       = ["${aws_sns_topic.security_alerts.arn}"]
}

resource "aws_cloudwatch_log_metric_filter" "console_without_mfa" {
  provider       = "aws.account-security"
  name           = "console-without-mfa"
  pattern        = "{$.eventName = ConsoleLogin && $.additionalEventData.MFAUsed = No}"
  log_group_name = "${aws_cloudwatch_log_group.cloudtrail.name}"

  metric_transformation {
    name      = "ConsoleWithoutMFACount"
    namespace = "${local.metrics_namespace}"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "console_without_mfa" {
  provider            = "aws.account-security"
  alarm_name          = "console-without-mfa"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ConsoleWithoutMFACount"
  namespace           = "${local.metrics_namespace}"
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "${local.alarm_prefix}Use of the console by an account without MFA has been detected"
  alarm_actions       = ["${aws_sns_topic.security_alerts.arn}"]
}

resource "aws_cloudwatch_log_metric_filter" "action_without_mfa" {
  provider       = "aws.account-security"
  name           = "action-without-mfa"
  pattern        = "{$.userIdentity.type != AssumedRole && $.userIdentity.sessionContext.attributes.mfaAuthenticated != true}"
  log_group_name = "${aws_cloudwatch_log_group.cloudtrail.name}"

  metric_transformation {
    name      = "UseWithoutMFACount"
    namespace = "${local.metrics_namespace}"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "action_without_mfa" {
  provider            = "aws.account-security"
  alarm_name          = "action-without-mfa"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "UseWithoutMFACount"
  namespace           = "${local.metrics_namespace}"
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "${local.alarm_prefix}Actions triggered by a user account without MFA has been detected"
  alarm_actions       = ["${aws_sns_topic.security_alerts.arn}"]
}

resource "aws_cloudwatch_log_metric_filter" "illegal_key_use" {
  provider       = "aws.account-security"
  name           = "key-changes"
  pattern        = "{$.eventSource = kms.amazonaws.com && ($.eventName = DeleteAlias || $.eventName = DisableKey)}"
  log_group_name = "${aws_cloudwatch_log_group.cloudtrail.name}"

  metric_transformation {
    name      = "KeyChangeOrDelete"
    namespace = "${local.metrics_namespace}"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "illegal_key_use" {
  provider            = "aws.account-security"
  alarm_name          = "key-changes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "KeyChangeOrDelete"
  namespace           = "${local.metrics_namespace}"
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "${local.alarm_prefix}A key alias has been changed or a key has been deleted"
  alarm_actions       = ["${aws_sns_topic.security_alerts.arn}"]
}

resource "aws_cloudwatch_log_metric_filter" "decription_with_key" {
  provider       = "aws.account-security"
  name           = "decription_with_key"
  pattern        = "{($.userIdentity.type = IAMUser || $.userIdentity.type = AssumeRole) && $.eventSource = kms.amazonaws.com && $.eventName = Decrypt}"
  log_group_name = "${aws_cloudwatch_log_group.cloudtrail.name}"

  metric_transformation {
    name      = "DecryptionWithKMS"
    namespace = "${local.metrics_namespace}"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "security_group_change" {
  provider       = "aws.account-security"
  name           = "security-group-changes"
  pattern        = "{ $.eventName = AuthorizeSecurityGroup* || $.eventName = RevokeSecurityGroup* || $.eventName = CreateSecurityGroup || $.eventName = DeleteSecurityGroup }"
  log_group_name = "${aws_cloudwatch_log_group.cloudtrail.name}"

  metric_transformation {
    name      = "SecurityGroupChanges"
    namespace = "${local.metrics_namespace}"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "security_group_change" {
  provider            = "aws.account-security"
  alarm_name          = "security-group-changes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "SecurityGroupChanges"
  namespace           = "${local.metrics_namespace}"
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "${local.alarm_prefix}Security groups have been changed"
  alarm_actions       = ["${aws_sns_topic.security_alerts.arn}"]
}

resource "aws_cloudwatch_log_metric_filter" "iam_change" {
  provider       = "aws.account-security"
  name           = "iam-changes"
  pattern        = "{$.eventSource = iam.* && $.eventName != Get* && $.eventName != List*}"
  log_group_name = "${aws_cloudwatch_log_group.cloudtrail.name}"

  metric_transformation {
    name      = "IamChanges"
    namespace = "${local.metrics_namespace}"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "iam_change" {
  provider            = "aws.account-security"
  alarm_name          = "iam-changes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "IamChanges"
  namespace           = "${local.metrics_namespace}"
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "${local.alarm_prefix}IAM Resources have been changed"
  alarm_actions       = ["${aws_sns_topic.security_alerts.arn}"]
}

resource "aws_cloudwatch_log_metric_filter" "routetable_change" {
  provider       = "aws.account-security"
  name           = "route-table-changes"
  pattern        = "{$.eventSource = ec2.* && ($.eventName = AssociateRouteTable || $.eventName = CreateRoute* || $.eventName = CreateVpnConnectionRoute || $.eventName = DeleteRoute* || $.eventName = DeleteVpnConnectionRoute || $.eventName = DisableVgwRoutePropagation || $.eventName = DisassociateRouteTable || $.eventName = EnableVgwRoutePropagation || $.eventName = ReplaceRoute*)}"
  log_group_name = "${aws_cloudwatch_log_group.cloudtrail.name}"

  metric_transformation {
    name      = "RouteTableChanges"
    namespace = "${local.metrics_namespace}"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "routetable_change" {
  provider            = "aws.account-security"
  alarm_name          = "route-table-changes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "RouteTableChanges"
  namespace           = "${local.metrics_namespace}"
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "${local.alarm_prefix}Route Table Resources have been changed"
  alarm_actions       = ["${aws_sns_topic.security_alerts.arn}"]
}

resource "aws_cloudwatch_log_metric_filter" "nacl_change" {
  provider       = "aws.account-security"
  name           = "nacl-changes"
  pattern        = "{$.eventSource = ec2.* && ($.eventName = CreateNetworkAcl* || $.eventName = DeleteNetworkAcl* || $.eventName = ReplaceNetworkAcl*)}"
  log_group_name = "${aws_cloudwatch_log_group.cloudtrail.name}"

  metric_transformation {
    name      = "NaclChanges"
    namespace = "${local.metrics_namespace}"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "nacl_change" {
  provider            = "aws.account-security"
  alarm_name          = "nacl-changes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "NaclChanges"
  namespace           = "${local.metrics_namespace}"
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "${local.alarm_prefix}NACL have been changed"
  alarm_actions       = ["${aws_sns_topic.security_alerts.arn}"]
}
