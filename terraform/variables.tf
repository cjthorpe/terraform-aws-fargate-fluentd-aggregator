variable "profile" {
  default = "thorpecorp"
}

variable "region" {
  default     = "eu-west-2"
  description = "The AWS region to create things in."
}

variable "service" {
  default = "fargate_fluentd"
  description = "The service being deployed."
}

variable "vpc_id" {
  default = "vpc-4e54e628"
}

variable "private_subnet_ids" {
  default = [ "subnet-9378b7f5", "subnet-4a9a4602" ]
  type = list
}

variable "public_subnet_ids" {
  default = [ "subnet-2777b841", "subnet-d399459b" ]
  type = list
}

variable "app_image" {
  default     = "adongy/hostname-docker:latest"
  description = "Docker image to run in the ECS cluster"
}

variable "app_name" {
  default = "fluentd-aggregator"
  description = "The name of this application."
}

variable "fluentd_port" {
  default     = 24224
  description = "Port used by the fluentd aggregator."
}

variable "desired_count" {
  default     = 1
  description = "Number of docker containers to run"
}

variable "fargate_cpu" {
  default     = "4096"
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
}

variable "fargate_memory" {
  default     = "8192"
  description = "Fargate instance memory to provision (in MiB)"
}

variable "log_retention_days" {
  default = "14"
  description = "Number of days to retain fluentd CloudWatch logs."
}

variable "scale_down_cpu_threshold" {
  default = 35
  description = "The value against which the specified statistic is compared."
}

variable "scale_down_period" {
  default = 600
  description = "The period in seconds over which the specified statistic is applied."
}

variable "scale_up_cpu_threshold" {
  default = 50
  description = "The value against which the specified statistic is compared."
}

variable "scale_up_period" {
  default = 60
  description = "The period in seconds over which the specified statistic is applied."
}
