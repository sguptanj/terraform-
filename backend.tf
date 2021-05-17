terraform {
  backend "s3" {
    bucket = "baseinfra-logs"
    key    = "web/terraform.tfstate"
    region = "us-east-1"
  }
}