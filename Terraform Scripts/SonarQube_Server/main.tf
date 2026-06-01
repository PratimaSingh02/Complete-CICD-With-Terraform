provider "aws" { region = var.aws_region }

resource "aws_instance" "sonarqube" {
  ami                    = data.aws_ami.amazonlinux2.id
  instance_type          = var.instance_type
  key_name               = var.my_key
  vpc_security_group_ids = [aws_security_group.sonar_sg.id]

  tags = { Name = "SonarQube-Server" }

  root_block_device {
    volume_size           = 25
    volume_type           = "gp3" # gp3 is the modern AWS standard (faster and cheaper than gp2)
    delete_on_termination = true  # Ensures AWS cleans up the storage when you run "terraform destroy"
  }

  # Automated handoff to your specific SonarQube Ansible playbook
  provisioner "local-exec" {
    command = <<EOT
      sleep 30;
      ansible-playbook -i '${self.public_ip},' --private-key=${var.my_key_path} ../../Playbooks/sonarqube-setup.yml
    EOT
  }
}
