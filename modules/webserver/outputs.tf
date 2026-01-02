# Instance ID Output
output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.this.id
}

# Public IP Output
output "public_ip" {
  description = "Public IP address of the instance"
  value       = aws_instance.this.public_ip
}

# Private IP Output
output "private_ip" {
  description = "Private IP address of the instance"
  value       = aws_instance.this.private_ip
}

# Instance ARN Output
output "instance_arn" {
  description = "ARN of the EC2 instance"
  value       = aws_instance.this.arn
}

# Key Pair Name Output
output "key_pair_name" {
  description = "Name of the SSH key pair"
  value       = aws_key_pair.this.key_name
}

# Availability Zone Output
output "availability_zone" {
  description = "Availability zone of the instance"
  value       = aws_instance.this.availability_zone
}

