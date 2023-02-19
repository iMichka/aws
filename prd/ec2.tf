resource "aws_instance" "mastodon-instance" {
  ami           = "ami-03605ed178c26cfab"
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.mastodon-instance-eni.id
    device_index         = 0
  }

  iam_instance_profile = aws_iam_instance_profile.mastodon-instance-profile.name

  user_data = <<EOF
#!/bin/bash
sudo mkdir /tmp/ssm
cd /tmp/ssm
wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb
sudo dpkg -i amazon-ssm-agent.deb
sudo systemctl enable amazon-ssm-agent
rm amazon-ssm-agent.deb
  EOF

  tags = {
    Name = "mastodon-instance"
  }

}

resource "aws_network_interface" "mastodon-instance-eni" {
  subnet_id       = aws_subnet.private-mastodon.id
  security_groups = [aws_security_group.main-security-group.id]

  tags = {
    Name = "mastodon-instance-eni"
  }
}

resource "aws_iam_instance_profile" "mastodon-instance-profile" {
  name = "mastodon-instance-profile"
  role = aws_iam_role.ssm-role.id
}
