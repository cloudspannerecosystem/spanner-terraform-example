terraform {
  required_version = ">= 0.13.1" # see https://releases.hashicorp.com/terraform/
}

locals {
  instance_name = format("%s-%s", var.instance_name, var.suffix)
  region        = var.region != "" ? var.region : data.google_client_config.google_client.region
  network_tags  = tolist(toset(var.network_tags))

  name_static_vm_ip = format("%s-ext-ip-%s", var.instance_name, var.suffix)

  sa_id = format("%s-sa-%s", var.instance_name, var.suffix)

  firewall_name = format("%s-fw-%s", var.instance_name, var.suffix)
}

resource "google_project_service" "compute_api" {
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "networking_api" {
  service            = "servicenetworking.googleapis.com"
  disable_on_destroy = false
}

resource "google_service_account" "omega_trade_sa" {
  account_id   = local.sa_id
  display_name = local.sa_id

  timeouts {
    create = var.sa_timeout
  }
}

resource "google_compute_address" "omega_trade_static_ip" {
  name       = local.name_static_vm_ip
  region     = local.region
  depends_on = [google_project_service.networking_api]

  timeouts {
    create = var.static_ip_timeout
    delete = var.static_ip_timeout
  }
}

resource "google_compute_instance" "omega_trade" {
  name         = local.instance_name
  machine_type = var.instance_machine_type
  zone         = format("%s-%s", local.region, var.zone)
  tags         = local.network_tags
  project      = var.project

  boot_disk {
    initialize_params {
      size  = var.boot_disk_size
      type  = var.boot_disk_type
      image = var.boot_disk_image
    }
  }
  network_interface {
    network = var.vpc_network_name
    access_config {
      nat_ip       = google_compute_address.omega_trade_static_ip.address
      network_tier = "PREMIUM"
    }
  }

  allow_stopping_for_update = var.allow_stopping_for_update
  lifecycle {
    ignore_changes = [
      attached_disk,
    ]
  }
  service_account {
    email  = google_service_account.omega_trade_sa.email
    scopes = ["cloud-platform"]
  }
  depends_on = [google_project_service.compute_api]

  metadata_startup_script = "${file("${path.module}/script.sh")}"

  timeouts {
    create = var.vm_instance_timeout
    update = var.vm_instance_timeout
    delete = var.vm_instance_timeout
  }
}

resource "google_project_iam_member" "spanner_role" {
  role   = "roles/spanner.viewer"
  member = "serviceAccount:${google_service_account.omega_trade_sa.email}"
}

resource "google_compute_firewall" "omega_trade_fw" {
  name    = local.firewall_name
  network = var.vpc_network_name

  allow {
    protocol = "tcp"
    ports    = ["22", "9010", "9020"]
  }

  target_tags = local.network_tags

  timeouts {
    create = var.firewall_timeout
    update = var.firewall_timeout
    delete = var.firewall_timeout
  }
}

data "google_client_config" "google_client" {}
