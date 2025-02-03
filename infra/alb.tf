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
