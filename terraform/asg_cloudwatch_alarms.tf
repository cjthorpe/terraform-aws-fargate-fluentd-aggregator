// ECS Service AutoScaling Alarm Definitions.

// Service CPU Utilisation is high - scale up.

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_description   = "This metric monitors ECS CPU for high utilization of application."
  alarm_name          = "${var.service}-${terraform.workspace}-cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "${var.scale_up_period}"
  statistic           = "Average"
  threshold           = "${var.scale_up_cpu_threshold}"

  alarm_actions = [
    "${aws_appautoscaling_policy.scale_up.arn}",
  ]

  dimensions = {
    ClusterName = "${aws_ecs_cluster.fluentd.name}"
    ServiceName = "${aws_ecs_cluster.fluentd.name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu-low" {
  alarm_description   = "This metric monitors ECS CPU for low utilization of application."
  alarm_name          = "${var.service}-${terraform.workspace}-cpu-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "${var.scale_down_period}"
  statistic           = "Average"
  threshold           = "${var.scale_down_cpu_threshold}"

  alarm_actions = [
    "${aws_appautoscaling_policy.scale_down.arn}",
  ]

  dimensions = {
    ClusterName = "${aws_ecs_cluster.fluentd.name}"
    ServiceName = "${aws_ecs_cluster.fluentd.name}"
  }
}
