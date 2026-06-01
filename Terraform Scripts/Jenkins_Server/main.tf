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

  root_block_device {
    volume_size           = 30
    volume_type           = "gp3" # gp3 is the modern AWS standard (faster and cheaper than gp2)
    delete_on_termination = true  # Ensures AWS cleans up the storage when you run "terraform destroy"
  }

  tags = {
    "Name" = "Jenkins-Server"
  }

# AUTOMATIC HAND-OFF TO ANSIBLE
   provisioner "local-exec" {
    command = <<EOT
      sleep 30;
      ANSIBLE_HOST_KEY_CHECKING=False OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES \
      ansible-playbook -i '${self.public_ip},' --private-key=${var.my_key_path} ../../Playbooks/jenkins-setup.yml
    EOT
  }
}