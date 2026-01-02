# Create unique SSH key pair for this instance
resource "aws_key_pair" "this" {
  key_name   = "${var.env_prefix}-${var.instance_name}-${var.instance_suffix}-key"
  public_key = file(var.public_key)

  tags = merge(
    var.common_tags,
    {
      Name = "${var.env_prefix}-${var.instance_name}-${var.instance_suffix}-key"
    }
  )
}

# Create EC2 instance
resource "aws_instance" "this" {
  # Amazon Linux 2023 AMI for me-central-1 region
  ami                         = "ami-05524d6658fcf35b6"
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  availability_zone           = var.availability_zone
  associate_public_ip_address = true
  key_name                    = aws_key_pair.this.key_name

  # User data script for instance initialization
  user_data = file(var.script_path)

  # Enable detailed monitoring (optional, for production)
  monitoring = false

  # Root block device configuration
  root_block_device {
    volume_size           = 8
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = false

    tags = merge(
      var.common_tags,
      {
        Name = "${var.env_prefix}-${var.instance_name}-${var.instance_suffix}-root-volume"
      }
    )
  }

  # Instance tags
  tags = merge(
    var.common_tags,
    {
      Name = "${var.env_prefix}-${var.instance_name}-${var.instance_suffix}"
      Role = var.instance_name
    }
  )

  # Ensure instance is created after key pair
  depends_on = [aws_key_pair.this]
}

