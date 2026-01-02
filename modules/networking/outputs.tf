# VPC ID Output
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

# Subnet ID Output
output "subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.public.id
}

# Internet Gateway ID Output
output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.this.id
}

# Route Table ID Output
output "route_table_id" {
  description = "The ID of the public route table"
  value       = aws_route_table.public.id
}

# VPC CIDR Block Output
output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}

# Subnet CIDR Block Output
output "subnet_cidr" {
  description = "The CIDR block of the public subnet"
  value       = aws_subnet.public.cidr_block
}

