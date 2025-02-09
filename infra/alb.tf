# Application Load Balancer
resource "aws_lb" "E-comApp_alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = split(",", data.aws_ssm_parameter.subnets.value) # Using SSM parameter list
} 

resource "aws_lb_target_group" "tg" {
  name        = var.lb_target_group
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value # Or data.aws_ssm_parameter.vpc_id.value  # Fetch from SSM instead of variables.tf. Run this AWS CLI command to store the VPC ID: aws ssm put-parameter --name "/E-comApp/vpc/vpc_id" --value "vpc-0528dc4e6cbc1eb6c" --type "String"
  target_type = "instance"

  health_check {
    enabled             = true
    interval            = 30
    path                = "/" #default health check path
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

# Attach EC2 Instance to Target Group
resource "aws_lb_target_group_attachment" "tg_attachment" {
  count = var.instance_count
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.ubuntu[count.index].id
  port             = 80
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.E-comApp_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# ALB Listener for HTTPS (port 443)
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.E-comApp_alb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = data.aws_ssm_parameter.ssl_cert_arn.value # Reference your SSL certificate ARN here

  default_action {
    type = "forward"
    forward {
      target_group {
        arn = aws_lb_target_group.tg.arn
      }
    }
  }
}