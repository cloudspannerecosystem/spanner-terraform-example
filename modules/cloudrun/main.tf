terraform {
  required_version = ">= 0.13.1" # see https://releases.hashicorp.com/terraform/
}

locals {
  service_name        = format("%s-%s", var.service_name, var.suffix)
  allow_authenticated = var.allow_unauth_access ? 1 : 0
  members             = var.iam_member == "" ? "allUsers" : var.iam_member
}

resource "google_project_service" "gcr_api" {
  service            = "containerregistry.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "cloud_run_api" {
  service            = "run.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "compute_api" {
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_cloud_run_service" "omega_trade" {
  name     = local.service_name
  location = var.region
  project  = var.project

  template {
    spec {
      containers {
        image = var.container_image_path
        ports {
          container_port = var.container_port
        }
        dynamic "env" {
          for_each = var.env_var
          content {
            name  = env.key
            value = env.value
          }
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = var.latest_revision
  }

  timeouts {
    create = var.cloud_run_timeout
    update = var.cloud_run_timeout
    delete = var.cloud_run_timeout
  }
}

resource google_cloud_run_service_iam_member public_access {
  count    = local.allow_authenticated
  service  = google_cloud_run_service.omega_trade.name
  location = google_cloud_run_service.omega_trade.location
  project  = google_cloud_run_service.omega_trade.project
  role     = "roles/run.invoker"
  member   = local.members
}
