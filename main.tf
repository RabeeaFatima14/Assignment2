# AWS Provider Configuration
provider "aws" {
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  region                   = "me-central-1"
}

# Data source to fetch current public IP
data "http" "my_ip" {
  url = "https://icanhazip.com"
}

# ========================================
# NETWORKING MODULE
# ========================================
# Creates VPC, Subnet, Internet Gateway, and Route Table
module "networking" {
  source = "./modules/networking"

  vpc_cidr_block    = var.vpc_cidr_block
  subnet_cidr_block = var.subnet_cidr_block
  availability_zone = var.availability_zone
  env_prefix        = var.env_prefix
}

# ========================================
# SECURITY MODULE
# ========================================
# Creates Security Groups for Nginx and Backend Servers
module "security" {
  source = "./modules/security"

  vpc_id     = module.networking.vpc_id
  env_prefix = var.env_prefix
  my_ip      = local.my_ip
}

# ========================================
# NGINX SERVER (Load Balancer / Reverse Proxy)
# ========================================
module "nginx_server" {
  source = "./modules/webserver"

  env_prefix        = var.env_prefix
  instance_name     = "nginx-proxy"
  instance_type     = var.instance_type
  availability_zone = var.availability_zone
  vpc_id            = module.networking.vpc_id
  subnet_id         = module.networking.subnet_id
  security_group_id = module.security.nginx_sg_id
  public_key        = var.public_key
  script_path       = "./scripts/nginx-setup.sh"
  instance_suffix   = "nginx"
  common_tags       = local.common_tags
}

# ========================================
# BACKEND WEB SERVERS (Apache)
# ========================================
# Creates 3 backend servers using for_each loop
module "backend_servers" {
  for_each = { for idx, server in local.backend_servers : server.name => server }

  source = "./modules/webserver"

  env_prefix        = var.env_prefix
  instance_name     = each.value.name
  instance_type     = var.instance_type
  availability_zone = var.availability_zone
  vpc_id            = module.networking.vpc_id
  subnet_id         = module.networking.subnet_id
  security_group_id = module.security.backend_sg_id
  public_key        = var.public_key
  script_path       = each.value.script_path
  instance_suffix   = each.value.suffix
  common_tags       = local.common_tags
}

