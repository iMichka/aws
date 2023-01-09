# resource "aws_instance" "app_server" {
#   ami           = "ami-03605ed178c26cfab"
#   instance_type = "t2.micro"

#   network_interface {
#     network_interface_id = aws_network_interface.app_server-eni.id
#     device_index         = 0
#   }

#   iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

#   user_data = <<EOF
# #!/bin/bash
# sudo mkdir /tmp/ssm
# cd /tmp/ssm
# wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb
# sudo dpkg -i amazon-ssm-agent.deb
# sudo systemctl enable amazon-ssm-agent
# rm amazon-ssm-agent.deb
#   EOF

#   tags = {
#     Name = "ExampleAppServerInstance"
#   }

# }

# resource "aws_network_interface" "app_server-eni" {
#   subnet_id       = aws_subnet.instance_subnet.id
#   security_groups = [aws_security_group.ingress-all-test.id]

#   tags = {
#     Name = "primary_network_interface"
#   }
# }

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ssm_role-ec2-role"
  role = aws_iam_role.ssm_role.id
}
