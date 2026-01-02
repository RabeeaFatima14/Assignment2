# Security Group for Nginx Load Balancer / Reverse Proxy
resource "aws_security_group" "nginx_sg" {
  name        = "${var.env_prefix}-nginx-sg"
  description = "Security group for Nginx reverse proxy and load balancer"
  vpc_id      = var.vpc_id

  # SSH Access - Only from your IP
  ingress {
    description = "SSH from my IP only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  # HTTP Access - From anywhere
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS Access - From anywhere
  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound - Allow all traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.env_prefix}-nginx-sg"
    Environment = var.env_prefix
    Project     = "Assignment-2"
    ManagedBy   = "Terraform"
    Role        = "Nginx-LoadBalancer"
  }
}

# Security Group for Backend Web Servers
resource "aws_security_group" "backend_sg" {
  name        = "${var.env_prefix}-backend-sg"
  description = "Security group for backend Apache web servers"
  vpc_id      = var.vpc_id

  # SSH Access - Only from your IP
  ingress {
    description = "SSH from my IP only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  # HTTP Access - Only from Nginx Security Group
  ingress {
    description     = "HTTP from Nginx load balancer only"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.nginx_sg.id]
  }

  # Outbound - Allow all traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.env_prefix}-backend-sg"
    Environment = var.env_prefix
    Project     = "Assignment-2"
    ManagedBy   = "Terraform"
    Role        = "Backend-WebServer"
  }
}

