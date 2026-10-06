terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Find the latest Ubuntu AMI automatically
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Create EC2 instance
resource "aws_instance" "gitops_ec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = {
    Name        = "GitOps-EC2"
    Environment = "Dev"
    ManagedBy   = "GitOps"
  }
}

# Display EC2 instance ID
output "instance_id" {
  value = aws_instance.gitops_ec2.id
}

# Display public IP
output "public_ip" {
  value = aws_instance.gitops_ec2.public_ip
}
