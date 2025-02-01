# Route 53 Setup
resource "aws_route53_record" "www" {
  zone_id = data.aws_ssm_parameter.zone_id.value # Fetch the Zone ID from SSM
  name    = var.domain_name                      # Your domain (e.g., "www.example.com")
  type    = "A"

  alias {
    name                   = aws_lb.E-comApp_alb.dns_name # Reference your ALB correctly
    zone_id                = aws_lb.E-comApp_alb.zone_id  # Reference the ALB's Zone ID
    evaluate_target_health = true                         # Ensures that Route 53 checks the ALB's health
  }
}
