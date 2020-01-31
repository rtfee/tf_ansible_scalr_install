output "mysql_instance_id" {
  description = "Instance ID"
  value       = aws_instance.mysql1.id
}

output "mysql_public_ip" {
  description = "Public IP"
  value       = aws_instance.mysql1.public_ip
}

output "mysql_private_ip" {
  description = "Private IP"
  value       = aws_instance.mysql1.private_ip
}

output "worker_instance_id" {
  description = "Instance ID"
  value       = aws_instance.worker.id
}

output "worker_public_ip" {
  description = "Public IP"
  value       = aws_instance.worker.public_ip
}

output "worker_private_ip" {
  description = "Private IP"
  value       = aws_instance.worker.private_ip
}
