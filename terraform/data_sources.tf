// Calculate the aws_subnet IPs from the provided public & private subnets.

data "aws_subnet" "private_subnets" {
  count = "${length(var.private_subnet_ids)}"
  id    = "${var.private_subnet_ids[count.index]}"
}

data "aws_subnet" "public_subnets" {
  count = "${length(var.public_subnet_ids)}"
  id    = "${var.public_subnet_ids[count.index]}"
}

