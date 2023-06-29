resource "aws_instance" "mastodon-instance" {
  ami           = "ami-03605ed178c26cfab"
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.mastodon-instance-eni.id
    device_index         = 0
  }

  root_block_device {
    volume_size = 30
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
sudo apt-add-repository ppa:ansible/ansible
sudo apt update
sudo apt install -y ansible awscli

# https://www.mattburkedev.com/adventures-in-mastodon-self-hosting-the-story-so-far/#more
# https://github.com/futurice/terraform-examples/blob/master/aws/aws_ec2_ebs_docker_host/provision-swap.sh
# Better add a swap file to compile mastodon / run it

SWAP_FILE_SIZE=4G
SWAPPINESS=10

echo "Setting up a swap file (size: $SWAP_FILE_SIZE, swappiness: $SWAPPINESS)..."

# Create the swap file
sudo fallocate -l $${SWAP_FILE_SIZE} /swapfile

# Only root should be able to access to this file
sudo chmod 600 /swapfile

# Define the file as swap space
sudo mkswap /swapfile

# Enable the swap file, allowing the system to start using it
sudo swapon /swapfile

# Make the swap file permanent, otherwise, previous settings will be lost on reboot
# Create a backup of the existing fstab, JustInCase(tm)
sudo cp /etc/fstab /etc/fstab.bak
# Add the swap file information at the end of the fstab
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# Adjust the swappiness
# With the default value of 10, the host will use swap if it has almost no other choice. Value is between 0 and 100.
# 100 will make the host use the swap as much as possible, 0 will make it use only in case of emergency.
# As swap access is slower than RAM access, having a low value here for a server is better.
sudo sysctl vm.swappiness=$${SWAPPINESS}

# Make this setting permanent, to not lose it on reboot
sudo cp /etc/sysctl.conf /etc/sysctl.conf.bak
echo "vm.swappiness=$${SWAPPINESS}" | sudo tee -a /etc/sysctl.conf
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
  role = aws_iam_role.ec2-role.id
}
