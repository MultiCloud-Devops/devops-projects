#----------------------------
# BE Security Group
#-------------------------------
resource "aws_security_group" "tfsp_be_sg" {
  name        = "tfsp-${var.envname}-be-sg"
  description = "Security group for BE instances"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.be_security_group_ingress
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
    Name = "tfsp-${var.envname}-be-sg"
  }
}

# #--------------------------
# # Instance Key Pair
# #-------------------------
# resource "aws_key_pair" "tfsp_be_key" {
#   key_name   = "tfsp-${var.envname}-key"
#   public_key = file("${path.module}/includes/my_pub_key.pub")
# }

# #-------------------------------------
# # IAM Role and Instance Profile
# #-------------------------------------

# resource "aws_iam_instance_profile" "be_lt_instance_profile" {
#   name = "tfsp-${var.envname}-be-instance-profile"
#   role = aws_iam_role.tfsp_be_instance_role.name
# }

#----------------------------
# Auto Scaling Group Launch Template 
#-------------------------------
resource "aws_launch_template" "tfsp_be_lt" {
  name_prefix   = "tfsp-${var.envname}-be-lt-"
  image_id      = var.be_asg_ami_id
  instance_type = var.be_asg_instance_type
  key_name      = aws_key_pair.tfsp_be_key.key_name

  iam_instance_profile {
    name = aws_iam_instance_profile.be_lt_instance_profile.name
  }
  user_data = base64encode(local.be_user_data)


  network_interfaces {
    associate_public_ip_address = false
    device_index                = 0
    security_groups             = [aws_security_group.tfsp_be_sg.id]
    subnet_id                   = var.subnet_id
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "tfsp-${var.envname}-be-lt"
    }
  }


  lifecycle {
    create_before_destroy = true
  }
}

#-----------------------------
# Auto Scaling Group
#-----------------------------
resource "aws_autoscaling_group" "tfsp_be_asg" {
  name = "tfsp-${var.envname}-be-asg"
  launch_template {
    id      = aws_launch_template.tfsp_be_lt.id
    version = "$Latest"
  }

  vpc_zone_identifier = var.vpc_private_subnets

  desired_capacity          = var.be_asg_desired_capacity          # 2
  max_size                  = var.be_asg_max_size                  #4
  min_size                  = var.be_asg_min_size                  #2
  health_check_grace_period = var.be_asg_health_check_grace_period #300
  health_check_type         = var.be_asg_health_check_type         #"EC2"


  tag {
    key                 = "Name"
    value               = "tfsp-${var.envname}-be-asg"
    propagate_at_launch = true
  }
  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_launch_template.tfsp_be_lt, aws_security_group.tfsp_be_sg]

}

resource "aws_autoscaling_attachment" "tfsp_be_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.tfsp_be_asg.name
  lb_target_group_arn    = var.be_asg_target_group_arn

}

#-----------------------------
# ASG Lifecycle Hook
#-----------------------------
resource "aws_autoscaling_lifecycle_hook" "foobar" {
  name                   = "instance-launch-hook"
  autoscaling_group_name = aws_autoscaling_group.tfsp_be_asg.name
  default_result         = "CONTINUE"
  heartbeat_timeout      = 300
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_LAUNCHING"
}

#-----------------------------
# ASG scaling policies
#-----------------------------
resource "aws_autoscaling_schedule" "tfsp-be-asg-scale-up-schedule" {
  scheduled_action_name  = "tfsp-${var.envname}-be-asg-scale-up-schedule"
  autoscaling_group_name = aws_autoscaling_group.tfsp_be_asg.name
  min_size               = var.be_asg_scale_up_min_size
  max_size               = var.be_asg_scale_up_max_size
  desired_capacity       = var.be_asg_scale_up_desired_capacity
  time_zone              = var.be_asg_scale_up_time_zone
  recurrence             = var.be_asg_scale_up_cron_expression
}

resource "aws_autoscaling_schedule" "tfsp-be-asg-scale-down-schedule" {
  scheduled_action_name  = "tfsp-${var.envname}-be-asg-scale-down-schedule"
  autoscaling_group_name = aws_autoscaling_group.tfsp_be_asg.name
  min_size               = var.be_asg_scale_down_min_size
  max_size               = var.be_asg_scale_down_max_size
  desired_capacity       = var.be_asg_scale_down_desired_capacity
  time_zone              = var.be_asg_scale_down_time_zone
  recurrence             = var.be_asg_scale_down_cron_expression
}

 