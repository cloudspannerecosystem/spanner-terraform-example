variable "spanner_instance_id" {
  type        = string
  description = "A unique identifier for the instance, which cannot be changed after the instance is created."
}

variable "spanner_dbname" {
  type        = string
  description = "A unique identifier for the database, which cannot be changed after the instance is created."
}

variable "spanner_config" {
  type        = string
  description = "Cloud Spanner Instance config - Regional / multi-region. For allowed configurations, check: https://cloud.google.com/spanner/docs/instances#available-configurations-regional"
}

variable "spanner_nodes" {
  type        = number
  description = "The number of nodes allocated to this instance. Comment num_nodes block if want to go with processing units, instead of node counts."
}

# variable "spanner_processing_units" {
#   type        = number
#   description = "The number of processing units allocated to this instance. Uncomment if want to go with processing units, instead of node counts."
# }

variable "spanner_labels" {
  type        = map(string)
  default     = {}
  description = "Labels to inject into the spanner instance."
}

variable "project" {
  type        = string
  description = "GCP Project ID"
}
