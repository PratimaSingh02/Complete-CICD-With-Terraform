output "jenkins_server_public_ip" {
  description = "The public IP address of the Jenkins server"
  value       = aws_instance.JenkinsServer.public_ip
}
