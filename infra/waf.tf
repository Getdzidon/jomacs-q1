
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

  # Prevent excessive requests from a single IP address to mitigate ddos attacks
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