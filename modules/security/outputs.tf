# Nginx Security Group ID Output
output "nginx_sg_id" {
  description = "Security group ID for Nginx load balancer"
  value       = aws_security_group.nginx_sg.id
}

# Backend Security Group ID Output
output "backend_sg_id" {
  description = "Security group ID for backend web servers"
  value       = aws_security_group.backend_sg.id
}

# Nginx Security Group Name Output
output "nginx_sg_name" {
  description = "Security group name for Nginx load balancer"
  value       = aws_security_group.nginx_sg.name
}

# Backend Security Group Name Output
output "backend_sg_name" {
  description = "Security group name for backend web servers"
  value       = aws_security_group.backend_sg.name
}

