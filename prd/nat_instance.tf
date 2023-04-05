resource "aws_instance" "nat-instance" {
  ami           = "ami-03605ed178c26cfab"
  instance_type = "t2.nano"

  network_interface {
    network_interface_id = aws_network_interface.nat-instance-eni.id
    device_index         = 0
  }

  iam_instance_profile = aws_iam_instance_profile.nat-instance-profile.name

  user_data = <<EOF
#!/bin/bash
sudo mkdir /tmp/ssm
cd /tmp/ssm
wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb
sudo dpkg -i amazon-ssm-agent.deb
sudo systemctl enable amazon-ssm-agent
rm amazon-ssm-agent.deb
sudo sysctl -w net.ipv4.ip_forward=1
sudo sysctl -p
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt install -y iptables-persistent
sudo /sbin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo service iptables save
  EOF

  tags = {
    Name = "nat-instance"
  }

}

resource "aws_network_interface" "nat-instance-eni" {
  subnet_id         = aws_subnet.public-mastodon.id
  security_groups   = [aws_security_group.main-security-group.id]
  source_dest_check = false

  tags = {
    Name = "nat-instance-eni"
  }
}

resource "aws_iam_instance_profile" "nat-instance-profile" {
  name = "nat-instance-profile"
  role = aws_iam_role.ec2-role.id
}

resource "aws_eip_association" "nat-instace-eip-association" {
  instance_id   = aws_instance.nat-instance.id
  allocation_id = aws_eip.mastodon-public-eip.id
}
