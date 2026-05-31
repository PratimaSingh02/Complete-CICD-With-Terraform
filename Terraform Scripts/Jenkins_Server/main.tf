terraform {
  required_version = "~> 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0" # Optional but recommended in production
    }
  }
}

provider "aws" {
  region = "us-east-2"
}
resource "aws_instance" "JenkinsServer" {
  ami                    = data.aws_ami.amazonlinux2.id
  instance_type          = var.my_instance_type
  key_name               = var.my_key
  vpc_security_group_ids = [aws_security_group.web-traffic.id]

  tags = {
    "Name" = "Jenkins-Server"
  }

# AUTOMATIC HAND-OFF TO ANSIBLE
   provisioner "local-exec" {
    command = <<EOT
      sleep 30;
      ansible-playbook -i '${self.public_ip},' --private-key=${var.my_key_path} ../Playbooks/jenkins-setup.yml
    EOT
  }
}