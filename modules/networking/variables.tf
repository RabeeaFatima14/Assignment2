# VPC CIDR Block
variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
}

# Subnet CIDR Block
variable "subnet_cidr_block" {
  type        = string
  description = "CIDR block for the public subnet"
}

# Availability Zone
variable "availability_zone" {
  type        = string
  description = "AWS availability zone for the subnet"
}

# Environment Prefix
variable "env_prefix" {
  type        = string
  description = "Environment prefix for resource naming and tags"
}

