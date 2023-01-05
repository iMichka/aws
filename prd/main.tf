terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.3.0"
}

provider "aws" {
  region = "eu-west-3"
}

resource "aws_s3_bucket" "imichka-terraform-state" {
  bucket = "imichka-terraform-state"
}

resource "aws_s3_bucket_versioning" "terraform_state_bucket_versioning" {
  bucket = aws_s3_bucket.imichka-terraform-state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "dynamodb_terraform_state_lock" {
  name           = "dynamodb_terraform_state_lock"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20
  tags = {
    Name = "DynamoDB Terraform State Lock Table"
  }
  attribute {
    name = "LockID"
    type = "S"
  }
}

terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "imichka-terraform-state"
    key            = "tfstate-s3-bucket"
    region         = "eu-west-3"
    dynamodb_table = "dynamodb_terraform_state_lock"
  }
}

resource "aws_vpc" "test-env" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "test-env"
  }
}

resource "aws_subnet" "instance_subnet" {
  cidr_block        = "10.0.1.0/24"
  vpc_id            = aws_vpc.test-env.id
  availability_zone = "eu-west-3a"
  tags = {
    Name = "instance_subnet"
  }
}

//security.tf
resource "aws_security_group" "ingress-all-test" {
  name   = "allow-all-sg"
  vpc_id = aws_vpc.test-env.id

  #allow http 
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # allow https
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

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

# ######################
# # EC2 Instance Role #
# ######################

resource "aws_iam_role" "ssm_role" {
  name = "ssm_role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": ["ec2.amazonaws.com", "ssm.amazonaws.com"]
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "SSM-role-policy-attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ssm_role-ec2-role"
  role = aws_iam_role.ssm_role.id
}

resource "aws_ssm_activation" "foo" {
  name               = "test_ssm_activation"
  description        = "Test"
  iam_role           = aws_iam_role.ssm_role.id
  registration_limit = "5"
  depends_on         = [aws_iam_role_policy_attachment.SSM-role-policy-attach]
}

resource "aws_subnet" "nat_gateway_subnet" {
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-3a"
  vpc_id            = aws_vpc.test-env.id
  tags = {
    "Name" = "DummySubnetNAT"
  }
}

resource "aws_internet_gateway" "nat_gateway" {
  vpc_id = aws_vpc.test-env.id
  tags = {
    "Name" = "DummyGateway"
  }
}

resource "aws_route_table" "nat_gateway" {
  vpc_id = aws_vpc.test-env.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nat_gateway.id
  }
}

resource "aws_route_table_association" "nat_gateway" {
  subnet_id      = aws_subnet.nat_gateway_subnet.id
  route_table_id = aws_route_table.nat_gateway.id
}


#resource "aws_eip" "nat_gateway" {
#  vpc = true
#}

#resource "aws_nat_gateway" "nat_gateway" {
#  allocation_id = aws_eip.nat_gateway.id
#  subnet_id     = aws_subnet.nat_gateway_subnet.id
#  tags = {
#    "Name" = "DummyNatGateway"
#  }
#}

#resource "aws_route_table" "instance_subnet" {
#  vpc_id = aws_vpc.test-env.id
#  route {
#    cidr_block     = "0.0.0.0/0"
#    nat_gateway_id = aws_nat_gateway.nat_gateway.id
#  }
#}

#resource "aws_route_table_association" "instance_subnet" {
#  subnet_id      = aws_subnet.instance_subnet.id
#  route_table_id = aws_route_table.instance_subnet.id
#}
