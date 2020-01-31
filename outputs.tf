output "instance_id" {
  description = "Instance ID"
  value       = aws_instance.mysql1.id
}

output "public_ip" {
  description = "Public IP"
  value       = aws_instance.mysql1.public_ip
}

output "private_ip" {
  description = "Private IP"
  value       = aws_instance.mysql1.private_ip
}

output "instance_id" {
  description = "Instance ID"
  value       = aws_instance.worker.id
}

output "public_ip" {
  description = "Public IP"
  value       = aws_instance.worker.public_ip
}

output "private_ip" {
  description = "Private IP"
  value       = aws_instance.worker.private_ip
}
