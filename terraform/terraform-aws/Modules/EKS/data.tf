
/*
I need to acces the remote state of my networking infrastructure
*/
data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket
    key    = var.remote_state_key
    region = var.remote_state_region
  }
}