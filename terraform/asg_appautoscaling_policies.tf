resource "aws_appautoscaling_target" "service_scale_target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.fluentd.name}/${aws_ecs_service.fluentd.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  max_capacity       = 4
  min_capacity       = 2

  depends_on = [
    "aws_ecs_service.fluentd"
  ]
}

// Scale up the group by adding 1 instance.

resource "aws_appautoscaling_policy" "scale_up" {
  name               = "${var.service}-${terraform.workspace}-scale-up"
  policy_type        = "StepScaling"
  resource_id        = "service/${aws_ecs_cluster.fluentd.name}/${aws_ecs_service.fluentd.name}"
  scalable_dimension = aws_appautoscaling_target.service_scale_target.scalable_dimension
  service_namespace  = "ecs"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 90
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }

  depends_on = [
    "aws_appautoscaling_target.service_scale_target"
  ]
}

// Scale down the group by removing 1 instance.

resource "aws_appautoscaling_policy" "scale_down" {
  name               = "${var.service}-${terraform.workspace}-scale-down"
  policy_type        = "StepScaling"
  resource_id        = "service/${aws_ecs_cluster.fluentd.name}/${aws_ecs_service.fluentd.name}"
  scalable_dimension = aws_appautoscaling_target.service_scale_target.scalable_dimension
  service_namespace  = "ecs"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }

  depends_on = [
    "aws_appautoscaling_target.service_scale_target"
  ]
}
