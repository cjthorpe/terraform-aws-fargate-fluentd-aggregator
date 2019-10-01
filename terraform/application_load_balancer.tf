resource "aws_lb" "fluentd" {
  internal           = false
  load_balancer_type = "network"
  name               = "fargate-fluentd-lb"
  subnets            = var.public_subnet_ids[*]
}

resource "aws_lb_target_group" "fluentd" {
  name        = "fargate-fluentd-tg"
  port        = var.fluentd_port
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  depends_on = ["aws_lb.fluentd"]
}

resource "aws_lb_listener" "fluentd" {
  load_balancer_arn = aws_lb.fluentd.arn
  port              = var.fluentd_port
  protocol          = "TCP"

  depends_on = ["aws_lb.fluentd"]

  default_action {
    target_group_arn = aws_lb_target_group.fluentd.arn
    type             = "forward"
  }
}
