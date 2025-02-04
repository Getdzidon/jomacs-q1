############ Outputs for useful information  ##############
output "security_group_id" {
  description = "The ID of the created security group"
  value       = aws_security_group.E-comApp_sg.id
}

# output "instance_ids" {
#   description = "The ID of the created EC2 instance"
#   value       = [for instance in aws_instance.E-comApp_server : instance.id]
# }

# output "instance_public_ips" {
#   description = "The public IP of the created EC2 instance"
#   value       = [for instance in aws_instance.E-comApp_server : instance.public_ip]
# }

# Output the ID of the Ubuntu AMI
output "ubuntu_ami_id" {
  value = data.aws_ami.ubuntu.id
}

############## Output to verify the ssm parameters ##############
# output "vpc_id" {
#   value = data.aws_ssm_parameter.vpc_id.value
# }

# output "vpc_cidr" {
#   value = data.aws_ssm_parameter.vpc_cidr.value
# }

# output "ssl_cert" {
#   value = data.aws_ssm_parameter.ssl_cert_arn.value
# }