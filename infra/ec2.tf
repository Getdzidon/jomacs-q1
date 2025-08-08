# EC2 Instance for Node.js App

resource "aws_instance" "ubuntu" {
  ami                    = data.aws_ami.ubuntu.id # reference from aws_ami data (from data.tf) source to get the latest Ubuntu AMI
  # Reference a variable for or use AMI ami = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type  # Reference a variable for instance type
  count                  = var.instance_count # Reference a variable for key pair
  key_name               = var.keypair_name
  vpc_security_group_ids = [aws_security_group.E-comApp_sg.id]                 # Use the existing SG #define a sg in variables and call it here. 
  subnet_id              = split(",", data.aws_ssm_parameter.subnets.value)[0] # use ssm parameter to dynamically call the first subnet.


  user_data = file("${path.module}/ec2_user_data_script.sh")

  tags = {
    Name = var.instance_name
  }
}
