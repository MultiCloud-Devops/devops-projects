#------------------------------------------
# ALB Security Group
#------------------------------------------
resource "aws_security_group" "tfsp_alb_sg" {
  name        = "tfsp-${var.envname}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.alb_security_group_ingress
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
    Name = "tfsp-${var.envname}-alb-sg"
  }
}

#------------------------------------------
# ALB Target Group
#------------------------------------------
resource "aws_lb_target_group" "tfsp_alb_tg" {
  name        = "tfsp-${var.envname}-alb-tg"
  port        = 8501
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    port                = "8501"
    protocol            = "HTTP"
    matcher             = "200-399"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 10
    timeout             = 6
  }

  tags = {
    Name = "tfsp-${var.envname}-alb-tg"
  }
}

#------------------------------------------
# ALB
#------------------------------------------
resource "aws_lb" "tfsp_alb" {
  name               = "tfsp-${var.envname}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.tfsp_alb_sg.id]
  subnets            = var.vpc_public_subnets

  tags = {
    Name = "tfsp-${var.envname}-alb"
  }
}

#------------------------------------------
# ALB Listener  
#------------------------------------------
resource "aws_lb_listener" "tfsp_alb_listener" {
  load_balancer_arn = aws_lb.tfsp_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tfsp_alb_tg.arn
  }
}