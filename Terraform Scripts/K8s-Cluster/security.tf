# ==============================================================================
# LAYER 1: SECURITY GROUP FOR THE EC2 INSTANCES (MASTER & WORKER NODES)
# ==============================================================================
resource "aws_security_group" "k8s_nodes_sg" {
  name        = "k8s-cluster-nodes-sg"
  description = "Firewall rules for K8s master and worker node communications"


  # All ports i.e. 1- 65535, all protocols, but only for traffic withing this sg
  ingress {
    description = "Allow all traffic originating within this security group"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  #  Allows Jenkins to execute deployments on the cluster
  ingress {
    description = "Allow Jenkins to access K8s API Server"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"] # JENKINS EC2 PRIVATE IP 
  }

  # Administrative SSH Access: For Ansible configuration scripts and manual triage
  ingress {
    description = "SSH administrative access from outside"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "k8s-nodes-sg"
  }
}
