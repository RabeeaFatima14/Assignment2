# Environment Prefix Variable
variable "env_prefix" {
  type        = string
  description = "Environment prefix for resource naming"
}

# Instance Name Variable
variable "instance_name" {
  type        = string
  description = "Name identifier for the instance"
}

# Instance Type Variable
variable "instance_type" {
  type        = string
  description = "EC2 instance type (e.g., t3.micro)"
}

# Availability Zone Variable
variable "availability_zone" {
  type        = string
  description = "AWS availability zone for the instance"
}

# VPC ID Variable
variable "vpc_id" {
  type        = string
  description = "VPC ID where the instance will be launched"
}

# Subnet ID Variable
variable "subnet_id" {
  type        = string
  description = "Subnet ID where the instance will be launched"
}

# Security Group ID Variable
variable "security_group_id" {
  type        = string
  description = "Security group ID to attach to the instance"
}

# Public Key Path Variable
variable "public_key" {
  type        = string
  description = "Path to SSH public key file"
}

# Script Path Variable
variable "script_path" {
  type        = string
  description = "Path to user data script for instance initialization"
}

# Instance Suffix Variable
variable "instance_suffix" {
  type        = string
  description = "Suffix to append to instance name for uniqueness"
}

# Common Tags Variable
variable "common_tags" {
  type        = map(string)
  description = "Common tags to apply to all resources"
}

