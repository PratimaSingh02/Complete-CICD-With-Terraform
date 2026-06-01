provider "aws" { region = var.aws_region }

resource "aws_instance" "nexus" {
  ami                    = data.aws_ami.amazonlinux2.id
  instance_type          = var.instance_type
  key_name               = var.my_key
  vpc_security_group_ids = [aws_security_group.nexus_sg.id]

  tags = { Name = "Nexus-Artifact-Server" }

  provisioner "local-exec" {
    command = <<EOT
      sleep 30;
      ansible-playbook -i '${self.public_ip},' --private-key=${var.my_key_path} ../../Playbooks/nexus-setup.yml
    EOT
  }
}
