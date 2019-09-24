provider "aws" {
  profile = "${var.profile}"
  region  = "${var.region}"

  //version = ">= 1.33.0"
}
