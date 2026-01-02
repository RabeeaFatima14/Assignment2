# VPC CIDR Block Variable
variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
  nullable    = false

  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]+$", var.vpc_cidr_block))
    error_message = "vpc_cidr_block must be a valid CIDR notation (e.g., 10.0.0.0/16)."
  }
}

# Subnet CIDR Block Variable
variable "subnet_cidr_block" {
  type        = string
  description = "CIDR block for the public subnet"
  nullable    = false

  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]+$", var.subnet_cidr_block))
    error_message = "subnet_cidr_block must be a valid CIDR notation (e.g., 10.0.10.0/24)."
  }
}

# Availability Zone Variable
variable "availability_zone" {
  type        = string
  description = "AWS availability zone for subnet and instances (e.g., me-central-1a)"
  nullable    = false
}

# Environment Prefix Variable
variable "env_prefix" {
  type        = string
  description = "Environment prefix used for resource naming and tags"
  nullable    = false
}

# Instance Type Variable
variable "instance_type" {
  type        = string
  description = "EC2 instance type for all web servers"
  default     = "t3.micro"

  validation {
    condition     = contains(["t2.micro", "t3.micro", "t2.small", "t3.small"], var.instance_type)
    error_message = "instance_type must be one of: t2.micro, t3.micro, t2.small, t3.small."
  }
}

# Public Key Variable
variable "public_key" {
  type        = string
  description = "Path to SSH public key file for EC2 instances"
  nullable    = false
}

# Private Key Variable
variable "private_key" {
  type        = string
  description = "Path to SSH private key file for connecting to EC2 instances"
  nullable    = false
}

# Backend Servers Variable
variable "backend_servers" {
  description = "List of backend web servers with configuration"
  type = list(object({
    name        = string
    suffix      = string
    script_path = string
  }))
  nullable = false
}

