data "terraform_remote_state" "base_infra" {
  backend = "s3"
  config = {
    bucket = "baseinfra-logs"
    key    = "baseInfra/terraform.tfstate"
    region = "us-east-1"
  }
}