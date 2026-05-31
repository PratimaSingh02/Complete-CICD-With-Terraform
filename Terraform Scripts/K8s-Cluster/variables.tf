variable "aws_region" {
  type        = string
  default     = "us-east-2"
}

variable "instance_type" {
  type        = string
  default     = "t2.medium"
}

variable "my_key" {
  type        = string
  description = "Name of your existing AWS SSH Key Pair"
  default     = "my-jenkins-ssh-key"
}

variable "my_key_path" {
  type        = string
  description = "Local path to your secret .pem key file"
  default     = "~/.ssh/my-jenkins-ssh-key.pem"
}
