resource "aws_lb" "lb" {
  name               = var.alb_name
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.alb_subnet_ids

  enable_deletion_protection = var.enable_deletion_protection

  tags = {
    Name = var.alb_name
  }
}

resource "aws_lb_target_group" "tg" {
  name     = var.alb_tg_name
  port     = var.alb_port
  protocol = "HTTP"
  vpc_id   = var.alb_tg_vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    matcher             = "200"
  }

  tags = {
    Name = var.alb_tg_name
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = var.alb_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
