resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/aws/ecs/${var.service}_${terraform.workspace}"
  retention_in_days = "${var.log_retention_days}"

  tags {
    Name        = "${var.service}_${terraform.workspace}"
    Environment = "${terraform.workspace}"
    Service     = "${var.service}"
  }
}

resource "aws_cloudwatch_log_group" "fluentd" {
  name = "/aws/ecs/fluentd"
  retention_in_days = "${var.log_retention_days}"

  tags {
    Name        = "${var.service}_${terraform.workspace}"
    Environment = "${terraform.workspace}"
    Service     = "${var.service}"
  }
}
