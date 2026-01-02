# VPC ID Variable
variable "vpc_id" {
  type        = string
  description = "VPC ID where security groups will be created"
}

# Environment Prefix Variable
variable "env_prefix" {
  type        = string
  description = "Environment prefix for resource naming and tags"
}

# My IP Variable
variable "my_ip" {
  type        = string
  description = "Current public IP with /32 CIDR for SSH access restriction"
}

