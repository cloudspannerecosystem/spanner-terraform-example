variable "cloud_run_service_name" {
  type        = string
  description = "Name of Google Cloud Run Service that being created."
}

variable "backend_container_image_path" {
  type        = string
  description = "Container Path of an application." // if using gcr, must be something: gcr.io/[PROJECT_NAME]/[APP]
}

variable "cloud_run_region" {
  type        = string
  description = "Region in which Google Cloud Run service would be deployed."
}

variable "cloud_run_env_var" {
  type        = map(string)
  default     = {}
  description = "Environment variables to inject into the service instance."
}

variable "project" {
  type        = string
  description = "GCP Project ID"
}
