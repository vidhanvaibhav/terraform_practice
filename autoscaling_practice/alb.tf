resource "aws_lb" "webapp_alb" {
  name               = "webapp-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_sg.id]
  subnets            = [aws_subnet.webapp_pubsub1.id, aws_subnet.webapp_pubsub2.id]

  tags = {
    Name = "webapp-alb"
  }
}


resource "aws_lb_target_group" "webapp_tg" {
  name     = "webapp-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.webapp_vpc.id

  health_check {
    path                = "/"
    interval            = 60
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 10
  }
}



resource "aws_lb_listener" "webapp_http_listener" {
  load_balancer_arn = aws_lb.webapp_alb.arn
  port              = "80"
  protocol          = "HTTP"

default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webapp_tg.arn
}
} 



