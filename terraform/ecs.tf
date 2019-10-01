resource "aws_ecs_cluster" "fluentd" {
  name = "fluentd-ecs-cluster"
}

resource "aws_ecs_task_definition" "fluentd" {
  container_definitions    = "${data.template_file.ecs.rendered}"
  cpu                      = "${var.fargate_cpu}"
  execution_role_arn       = "${aws_iam_role.fluentd_ecs_task_execution.arn}"
  family                   = "${var.app_name}"
  memory                   = "${var.fargate_memory}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = "${aws_iam_role.fluentd_ecs_task.arn}"
}

resource "aws_ecs_service" "fluentd" {
  cluster         = "${aws_ecs_cluster.fluentd.name}"
  desired_count   = "${var.desired_count}"
  launch_type     = "FARGATE"
  name            = "fluentd-ecs-service"
  task_definition = "${aws_ecs_task_definition.fluentd.arn}"

  network_configuration {
    security_groups = ["${aws_security_group.fluentd_alb_sg.id}"]
    subnets         = "${var.private_subnet_ids[*]}"
  }

  load_balancer {
    target_group_arn = "${aws_lb_target_group.fluentd.arn}"
    container_name   = "fluentd-aggregator"
    container_port   = "${var.fluentd_port}"
  }

  depends_on = [
    "aws_lb_listener.fluentd"
  ]
}

# Task Definition Template.
# Apply configurables to the AWS taskdef JSON.
#
data "template_file" "ecs" {
  template = "${file("templates/task-definition.json")}"

  vars = {
    app_name = "${var.app_name}"
    fargate_cpu      = "${var.fargate_cpu}"
    fargate_memory   = "${var.fargate_memory}"
    fluentd_port     = "${var.fluentd_port}"
    log_group_name   = "${aws_cloudwatch_log_group.ecs.name}"
    log_group_region = "${var.region}"
  }
}
