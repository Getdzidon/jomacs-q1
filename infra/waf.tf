resource "aws_wafv2_web_acl" "waf_acl" {
  name        = var.waf_name
  description = "Simple WAF for e-commerce website with rate limiting"
  scope       = "REGIONAL"  # Use "CLOUDFRONT" if using CloudFront for global resources

  default_action {
    allow {}
  }

  # Managed Rule Group for SQL Injection (SQLi) attacks
  rules {
    name     = "SQLiRule"
    priority = 1
    action   = {
      allow {}
    }
    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        rule_group_name = "AWSManagedRulesSQLiRuleSet"
      }
    }
  }

  # Managed Rule Group for XSS attacks
  rules {
    name     = "XSSRule"
    priority = 2
    action   = {
      allow {}
    }
    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        rule_group_name = "AWSManagedRulesXSSRuleSet"
      }
    }
  }

  # Rate Limit Rule to block requests exceeding 1000 requests in 5 minutes to prevent/mitigate DDoS attack
  rules {
    name     = "RateLimitRule"
    priority = 3
    action   = {
      block {}
    }
    statement {
      rate_based_statement {
        limit = 1000
        aggregate_key_type = "IP"
        scope_down_statement {
          byte_match_statement {
            search_string = "GET"
            field_to_match {
              single_header {
                name = "User-Agent"
              }
            }
            positional_constraint = "CONTAINS"
            text_transformation {
              type = "NONE"
            }
          }
        }
      }
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name               = "WAFMetric"
    sampled_requests_enabled  = true
  }

  tags = {
    "Environment" = "Production"
    "Compliance"  = "SOC 2"
  }
}

# CloudWatch log group for WAF logs (for SOC 2 auditing)
resource "aws_cloudwatch_log_group" "waf_log_group" {
  name = "/aws/waf-logs"
}

# Logging configuration for WAF to send logs to CloudWatch
resource "aws_wafv2_web_acl_logging_configuration" "waf_log_config" {
  resource_arn = aws_wafv2_web_acl.waf_acl.arn
  log_destination_configs = [
    aws_cloudwatch_log_group.waf_log_group.arn
  ]
}
