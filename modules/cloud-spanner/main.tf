terraform {
  required_version = ">= 0.13.1" # see https://releases.hashicorp.com/terraform/
}

locals {
  instance_id           = format("%s-%s", var.instance_id, var.suffix)
  instance_display_name = format("%s-%s", var.instance_display_name, var.suffix)
  display_name          = var.instance_display_name == "" ? local.instance_id : local.instance_display_name
  dbname                = format("%s-%s", var.dbname, var.suffix)
}

resource "google_project_service" "compute_api" {
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "spanner_api" {
  service            = "spanner.googleapis.com"
  disable_on_destroy = false
}

resource "google_spanner_instance" "omega_trade" {
  name         = local.instance_id
  config       = var.config
  display_name = local.display_name
  num_nodes    = var.num_nodes
  labels       = var.labels_var
  project      = var.project

  timeouts {
    create = var.spanner_instance_timeout
    update = var.spanner_instance_timeout
    delete = var.spanner_instance_timeout
  }
}

resource "google_spanner_database" "omega_trade_database" {
  instance            = google_spanner_instance.omega_trade.name
  name                = local.dbname
  ddl                 = var.ddl_queries
  deletion_protection = var.deletion_protection

  timeouts {
    create = var.spanner_db_timeout
    update = var.spanner_db_timeout
    delete = var.spanner_db_timeout
  }
}
