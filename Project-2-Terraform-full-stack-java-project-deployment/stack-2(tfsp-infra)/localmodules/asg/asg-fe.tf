#----------------------------------------------------------
# Security Group for Launch Template
#----------------------------------------------------------
resource "aws_security_group" "tfsp-fe_sg" {
  name        = "tfsp-${var.envname}-fe-sg"
  description = "Security group for FE instances"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.fe_security_group_ingress
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "tfsp-${var.envname}-fe-sg"
  }
}

#----------------------------------------------------------
# Launch Template for Auto Scaling Group    
#----------------------------------------------------------
resource "aws_launch_template" "tfsp_fe_lt" {
  name_prefix   = "tfsp-${var.envname}-fe-lt-"
  image_id      = var.fe_asg_ami_id
  instance_type = var.fe_asg_instance_type
  key_name      = aws_key_pair.tfsp_be_key.key_name

  iam_instance_profile {
    name = aws_iam_instance_profile.be_lt_instance_profile.name
  }

  user_data = base64encode(local.fe_user_data)

  network_interfaces {
    associate_public_ip_address = true
    device_index                = 0
    security_groups             = [aws_security_group.tfsp-fe_sg.id]
    subnet_id                   = var.subnet_id
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "tfsp-${var.envname}-fe-instance"
    }
  }
}

# #----------------------------------------------------------
# # Auto Scaling Group    
# #----------------------------------------------------------
resource "aws_autoscaling_group" "tfsp_fe_asg" {
  name                      = "tfsp-${var.envname}-fe-asg"
  max_size                  = var.fe_asg_max_size
  min_size                  = var.fe_asg_min_size
  desired_capacity          = var.fe_asg_desired_capacity
  health_check_grace_period = var.fe_asg_health_check_grace_period
  health_check_type         = var.fe_asg_health_check_type
  vpc_zone_identifier       = var.vpc_private_subnets
  launch_template {
    id      = aws_launch_template.tfsp_fe_lt.id
    version = "$Latest"
  }
  target_group_arns = [var.fe_asg_target_group_arn]

  tag {
    key                 = "Name"
    value               = "tfsp-${var.envname}-fe-asg"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}