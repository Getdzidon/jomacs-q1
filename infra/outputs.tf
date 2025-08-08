############ Outputs for useful information  ##############
output "security_group_id" {
  description = "The ID of the created security group"
  value       = aws_security_group.E-comApp_sg.id
  # sensitive = false
}

# output "instance_ids" {
#   description = "The ID of the created EC2 instance"
#   value       = [for instance in aws_instance.E-comApp_server : instance.id]
#   sensitive   = true
# }

# output "instance_public_ips" {
#   description = "The public IP of the created EC2 instance"
#   value       = [for instance in aws_instance.E-comApp_server : instance.public_ip]
#   sensitive   = true
# }

# Output the ID of the Ubuntu AMI
output "ubuntu_ami_id" {
  value = data.aws_ami.ubuntu.id
  # sensitive = false
}

############## Output to verify the ssm parameters ##############
# output "vpc_id" {
#   value = data.aws_ssm_parameter.vpc_id.value
#   sensitive   = true
# }

# output "vpc_cidr" {
#   value = data.aws_ssm_parameter.vpc_cidr.value
#   sensitive   = true
# }

# output "ssl_cert" {
#   value = data.aws_ssm_parameter.ssl_cert_arn.value
#   sensitive   = true
# }