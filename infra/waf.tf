# Fetch AWS account details
data "aws_caller_identity" "current" {}

# Create a CloudWatch Log Group for WAF logs
resource "aws_cloudwatch_log_group" "waf_logs" {
  name              = "/aws/waf/${var.waf_name}"
  retention_in_days = 30
}

# Add a Resource Policy to allow AWS WAF to write logs to CloudWatch
resource "aws_cloudwatch_log_resource_policy" "waf_logs_policy" {
  policy_name = "AWSWAFLoggingPolicy"
  policy_document = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "waf.amazonaws.com"
      },
      "Action": "logs:PutLogEvents",
      "Resource": "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/waf/${var.waf_name}"
    }
  ]
}
EOT
}

# Define AWS WAF Web ACL
resource "aws_wafv2_web_acl" "WafWebAcl" {
  name        = var.waf_name
  description = "Simple WAF for e-commerce website with rate limiting"
  scope       = "REGIONAL" # Use "CLOUDFRONT" if using CloudFront for global resources

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "WAF_Common_Rule"
    sampled_requests_enabled   = true
  }


  rule {
    name     = "HandleOversizedRequests"
    priority = 1

    action {
      allow {}
    }

    statement {
      size_constraint_statement {
        comparison_operator = "GT"
        size                = 43716
        field_to_match {
          body {
            oversize_handling = "CONTINUE"
          }
        }
        text_transformation {
          priority = 0
          type     = "NONE"
        }
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "HandleOversizedRequests"
      sampled_requests_enabled   = true
    }
  }

  # Rule to prevent excessive requests from a single IP address (DDoS mitigation)
  rule {
    name     = "RateLimitRequests"
    priority = 5

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 500
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateLimit"
      sampled_requests_enabled   = true
    }

  }
# AWS Managed Rules for common vulnerabilities
  rule {

    name     = "AWS-ManagedRulesCommonRuleSet"
    priority = 10

    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"

        rule_action_override {

          action_to_use {
            allow {}
          }

          name = "SizeRestrictions_BODY"
        }

        rule_action_override {

          action_to_use {
            allow {}
          }
          name = "NoUserAgent_HEADER"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-ManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }
}

# Enable WAF logging to CloudWatch
resource "aws_wafv2_web_acl_logging_configuration" "waf_logging" {
  log_destination_configs = [aws_cloudwatch_log_group.waf_logs.arn] 
  resource_arn           = aws_wafv2_web_acl.WafWebAcl.arn

  depends_on = [aws_cloudwatch_log_resource_policy.waf_logs_policy] # Ensure policy is applied first
}