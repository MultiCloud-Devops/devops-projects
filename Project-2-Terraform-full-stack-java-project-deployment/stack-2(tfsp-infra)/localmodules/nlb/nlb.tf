#-------------------------------
# NLB Securtiy Group
#-------------------------------
resource "aws_security_group" "tfsp_nlb_security_group" {
  name        = "tfsp-${var.envname}-nlb-sg"
  description = "Security group for BE NLB"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.nlb_security_group_ingress
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
    Name = "tfsp-${var.envname}-nlb-sg"
  }
}



#-------------------------------
# NLB Target Group
#-------------------------------
resource "aws_lb_target_group" "tfsp_nlb_tg" {
  name        = "tfsp-${var.envname}-nlb-tg"
  port        = 8084
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/actuator"
    port                = "8084"
    protocol            = "HTTP"
    matcher             = "200-399"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 10
    timeout             = 6
  }

  tags = {
    Name = "tfsp-${var.envname}-be-nlb-tg"
  }
}

#-------------------------------
# NLB   
#-------------------------------
resource "aws_lb" "tfsp_nlb" {
  name               = "tfsp-${var.envname}-nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = var.vpc_private_subnets
  security_groups    = [aws_security_group.tfsp_nlb_security_group.id]

  tags = {
    Name = "tfsp-${var.envname}-nlb"
  }
}

#-------------------------------
# NLB Listener
#-------------------------------
resource "aws_lb_listener" "tfsp_nlb_listener" {
  load_balancer_arn = aws_lb.tfsp_nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tfsp_nlb_tg.arn
  }
}




 