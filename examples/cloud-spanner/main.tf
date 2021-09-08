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
  source      = "../../modules/cloud-spanner"
  suffix      = local.suffix
  instance_id = var.spanner_instance_id
  dbname      = var.spanner_dbname
  config      = var.spanner_config
  num_nodes   = var.spanner_nodes # comment num_nodes and uncomment processing_units if want to go with processing_units instead of node counts
  # processing_units = var.spanner_processing_units
  labels_var  = var.spanner_labels
  project     = var.project
}
