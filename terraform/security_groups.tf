resource "aws_security_group" "fluentd_alb_sg" {
  description = "Control access to the ALB."
  name        = "fluentd-alb_sg"
  vpc_id      = "${var.vpc_id}"

  ingress {
    description = "Allow ingress on port 24224 for the fluentd aggregator."
    from_port   = "${var.fluentd_port}"
    protocol    = "tcp"
    to_port     = "${var.fluentd_port}"

    cidr_blocks = [
      "${data.aws_subnet.private_subnets.*.cidr_block}",
      "${data.aws_subnet.public_subnets.*.cidr_block}",
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

/*resource "aws_security_group" "ecs_tasks" {
  name        = "tf-ecs-tasks"
  description = "Allow inbound traffic to tasks from the ALB only."
  vpc_id      = "${var.vpc_id}"

  ingress {
    protocol        = "tcp"
    from_port       = "${var.fluentd_port}"
    to_port         = "${var.fluentd_port}"
    security_groups = ["${aws_security_group.lb.id}"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}*/

