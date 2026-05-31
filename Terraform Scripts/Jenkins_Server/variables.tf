variable "region" {
  type    = string
  default = "us-east-2"
}
variable "my_instance_type" {
  type    = string
  default = "t2.medium" # 2 CPU and 4 GB RAM
}


variable "my_key" {
  description = "AWS EC2 Key pair that needs to be associated with EC2 Instance"
  type        = string
  default     = "my-jenkins-ssh-key"
}

variable "my_key_path" {
  type        = string
  description = "The absolute local file path to  downloaded AWS .pem private key"
  default     = "~/.ssh/my-jenkins-ssh-key.pem" # <-- Update this to your path
}

variable "ingressrules" {
  type    = list(number)
  default = [22, 80, 443, 8080, 8090, 9000, 8081, 2479]
}

variable "egressrules" {
  type    = list(number)
  default = [25, 80, 443, 8080, 8090, 3306, 53]
}