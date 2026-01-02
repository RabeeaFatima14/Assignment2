# Nginx Server Outputs
output "nginx_public_ip" {
  description = "Public IP address of the Nginx load balancer"
  value       = module.nginx_server.public_ip
}

output "nginx_instance_id" {
  description = "Instance ID of the Nginx server"
  value       = module.nginx_server.instance_id
}

# Backend Server Outputs
output "backend_public_ips" {
  description = "Map of backend server names to their public IPs"
  value       = { for name, mod in module.backend_servers : name => mod.public_ip }
}

output "backend_private_ips" {
  description = "Map of backend server names to their private IPs"
  value       = { for name, mod in module.backend_servers : name => mod.private_ip }
}

output "backend_instance_ids" {
  description = "Map of backend server names to their instance IDs"
  value       = { for name, mod in module.backend_servers : name => mod.instance_id }
}

# Network Outputs
output "vpc_id" {
  description = "VPC ID"
  value       = module.networking.vpc_id
}

output "subnet_id" {
  description = "Public subnet ID"
  value       = module.networking.subnet_id
}

# Security Group Outputs
output "nginx_security_group_id" {
  description = "Security group ID for Nginx server"
  value       = module.security.nginx_sg_id
}

output "backend_security_group_id" {
  description = "Security group ID for backend servers"
  value       = module.security.backend_sg_id
}

# My IP Output
output "my_current_ip" {
  description = "Current public IP used for SSH access"
  value       = local.my_ip
}

