# Create Security Group - SSH Traffic and other ports
resource "aws_security_group" "web-traffic" {
  name = "My_Security_Group1"

  ingress {
    description = "SSH from my local IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.0.2.1/32"] 
  }

  # 2. Jenkins Web UI Access (For you to access the dashboard)
  ingress {
    description = "Jenkins Web UI from my local IP"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["192.0.2.1/32"] 
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "My_SG1"
  }
}
