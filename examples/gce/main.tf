terraform {
  required_version = ">= 0.13.1" # see https://releases.hashicorp.com/terraform/
}

provider "google" {
  version = "3.51.0" # see https://github.com/terraform-providers/terraform-provider-google/releases
  project = var.project
}

resource "random_string" "launch_id" {
  length  = 4
  special = false
  upper   = false
}

locals {
  suffix = format("%s-%s", "tf", random_string.launch_id.result)
}

module omegatrade {
  source           = "../../modules/gce"
  suffix           = local.suffix
  region           = var.gce_region
  vpc_network_name = var.vpc_network_name
  instance_name    = var.gce_instance_name
  network_tags     = var.gce_network_tags
  project          = var.project
}
