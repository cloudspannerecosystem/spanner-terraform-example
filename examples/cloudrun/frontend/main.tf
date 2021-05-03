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

module "cloud_run_frontend" {
  source               = "../../../modules/cloudrun"
  suffix               = local.suffix
  service_name         = "${var.cloud_run_service_name}-frontend"
  container_image_path = var.backend_container_image_path
  region               = var.cloud_run_region
  project              = var.project
}
