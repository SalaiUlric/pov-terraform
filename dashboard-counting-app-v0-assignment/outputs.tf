output "Dashboard_Instance_public_ip" {
  description = "The public IP address of the dashboard EC2 instance"
  value       = aws_instance.Dashboard_Instance.public_ip
}

output "Dashboard_Instance_private_ip" {
  description = "The private IP address of the dashboard EC2 instance"
  value       = aws_instance.Dashboard_Instance.private_ip
}

output "Counting_Instance_private_ip" {
  description = "The private IP address of the counting EC2 instance"
  value       = aws_instance.Counting_Instance.private_ip
}

output "ssh_private_key" {
  description = "The private SSH key for accessing the EC2 instances"
  value       = local_file.ssh_private_key.filename
}
