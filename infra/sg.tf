# Security Group for Application Load Balancer (ALB)
resource "aws_security_group" "alb_sg" {
  name        = "${var.instance_name}-alb-security-group"
  description = "Security group controlling access to the ALB"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value

  # Allow inbound HTTP traffic (port 80) from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow inbound HTTPS traffic (port 443) from anywhere (Optional)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outbound traffic to anywhere to allow the LB to hit anywhere on the internet 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group for EC2 Instance (E-comApp Server/vm) This is very important and critical
resource "aws_security_group" "E-comApp_sg" {
  name        = "${var.instance_name}-ec2-security-group"
  description = "Security group for the EC2 instance on which the application is deployed"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value

  # Allow inbound SSH (port 22) only from your IP (Replace with your actual IP)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Note that in a work environment, this will be restricted to only my IP ["MY_PUBLIC_IP/32"], a jump/bastion server, or a specific IP range (Eg. vpn CIDR BLOCK). Do not allow SSH from everywhere. Or, I would consider changing the SSH port to something other than 22.
  }

  # Allow inbound HTTP (port 80) from ALB
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # Allow ICMP (ping) from anywhere
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"] # Note that in a work environment, this should be restricted to only your IP, a jump/bastion server, or a specific IP range
  }

  # Allow outbound traffic to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
