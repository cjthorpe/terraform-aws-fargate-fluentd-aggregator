/*
resource "aws_iam_instance_profile" "ecs" {
  name = "${var.service}-${terraform.env}"
  role = "${aws_iam_role.ecs.name}"
}

data "aws_iam_policy_document" "ecs" {
  statement {
    actions = [
      "autoscaling:Describe*",
      "autoscaling:UpdateAutoScalingGroup",
      "cloudwatch:GetMetricStatistics",
      "iam:ListInstanceProfiles",
      "iam:ListRoles",
      "iam:PassRole",
      "ecs:*",
      "ecs:CreateCluster",
      "ecs:DeregisterContainerInstance",
      "ecs:DiscoverPollEndpoint",
      "ecs:Poll",
      "ecs:RegisterContainerInstance",
      "ecs:StartTelemetrySession",
      "ecs:Submit*",
      "ecs:StartTask",
      "ecs:ListServices",
      "ecs:DescribeTasks",
      "ecs:DescribeServices",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecs:ListClusters",
      "ecs:ListContainerInstances",
      "ecs:DescribeContainerInstances",
      "ec2:DescribeInstances",
      "ecs:DescribeTags",
      "autoscaling:DescribeAutoScalingInstances",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:RegisterTargets",
      "xray:*"
    ]

    resources = [
      "*",
    ]
  }
}*/

// "Task execution" role and policy document definitions.

// 1. "Task execution" assume role policy document.

data "aws_iam_policy_document" "fluentd_ecs_task_execution_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    sid     = "AllowECSTasksToAssumeRole"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

// 2. "Task execution" role policy document.

data "aws_iam_policy_document" "fluentd_ecs_task_execution_role" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    effect = "Allow"
    sid    = "AllowECSToWriteLogsToCloudWatch"

    resources = ["${aws_cloudwatch_log_group.fluentd.arn}"]
  }
}

// 3. "Task execution" role.

resource "aws_iam_role" "fluentd_ecs_task_execution" {
  assume_role_policy = "${data.aws_iam_policy_document.fluentd_ecs_task_execution_assume_role.json}"
  name               = "fluentd_ecs_task_execution"
}

// 4. "Task execution" role policy.

resource "aws_iam_role_policy" "fluentd_ecs_task_execution" {
  name   = "fluentd_ecs_task_execution"
  policy = "${data.aws_iam_policy_document.fluentd_ecs_task_execution_role.json}"
  role   = "${aws_iam_role.fluentd_ecs_task_execution.id}"
}

// Task role and policy document definitions.

// 1. Task assume role policy document.

data "aws_iam_policy_document" "fluentd_ecs_task_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    sid     = "AllowECSTasksToAssumeRole"

    principals {
      identifiers = ["ecs-tasks.amazonaws.com"]
      type        = "Service"
    }
  }
}

// 2. Task role.

resource "aws_iam_role" "fluentd_ecs_task" {
  assume_role_policy = "${data.aws_iam_policy_document.fluentd_ecs_task_assume_role.json}"
  name               = "fluentd_ecs_task"
}

// Application auto-scaling role and policy document definitions.

// 1. Auto-scaling assume role policy document.

data "aws_iam_policy_document" "fluentd_scaling_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    sid     = "AllowAppAutoScalingToAssumeRole"

    principals {
      identifiers = ["application-autoscaling.amazonaws.com"]
      type        = "Service"
    }
  }
}

// 2. Auto-scaling role policy document.

data "aws_iam_policy_document" "fluentd_scaling_role" {
  statement {
    actions = [
      "application-autoscaling:*",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:GetMetricStatistics",
      "ecs:DescribeServices",
      "ecs:UpdateService"
    ]
    effect = "Allow"
    sid    = "AllowFluentdAggregatorScaling"

    resources = ["*"]
  }
}

// 3. Auto-scaling role.

resource "aws_iam_role" "fluentd_scaling" {
  assume_role_policy = "${data.aws_iam_policy_document.fluentd_scaling_assume_role.json}"
  name               = "fluentd_scaling"
}

resource "aws_iam_role_policy" "fluentd_scaling" {
  name   = "fluentd_scaling"
  policy = "${data.aws_iam_policy_document.fluentd_scaling_role.json}"
  role   = "${aws_iam_role.fluentd_scaling.id}"
}
