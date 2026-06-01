provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "master" {
  ami                    = data.aws_ami.amazonlinux2.id
  instance_type          = var.instance_type
  key_name               = var.my_key
  
  # References the node security group defined inside security.tf
  vpc_security_group_ids = [aws_security_group.k8s_nodes_sg.id]

  root_block_device {
    volume_size           = 25
    volume_type           = "gp3" 
    delete_on_termination = true  
  }

  tags = {
    Name = "K8s-Master"
    Role = "master"
  }
}

resource "aws_instance" "workers" {
  count                  = 2
  ami                    = data.aws_ami.amazonlinux2.id
  instance_type          = var.instance_type
  key_name               = var.my_key
  
  vpc_security_group_ids = [aws_security_group.k8s_nodes_sg.id]

  root_block_device {
    volume_size           = 25
    volume_type           = "gp3" # gp3 is the modern AWS standard (faster and cheaper than gp2)
    delete_on_termination = true  # Ensures AWS cleans up the storage when you run "terraform destroy"
  }

  tags = {
    Name = "K8s-Worker-${count.index + 1}"
    Role = "worker"
  }
}

# 4. Automated Hand-off to Ansible Playbook
resource "null_resource" "k8s_bootstrap" {
  triggers = {
    master_id  = aws_instance.master.id
    worker_ids = join(",", aws_instance.workers.*.id)
  }

  provisioner "local-exec" {
    command = <<EOT
      sleep 30;
      ansible-playbook \
        -i '${aws_instance.master.public_ip},' \
        --extra-vars "worker1=${aws_instance.workers[0].public_ip} worker2=${aws_instance.workers[1].public_ip}" \
        --private-key=${var.my_key_path} \
        ../../Playbooks/k8s-cluster-setup.yml
    EOT
  }
}
