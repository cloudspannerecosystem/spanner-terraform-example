## --- REQUIRED PARAMETERS ------------------------------------------------------------------------------------------------

variable "gce_region" {
  type        = string
  description = "Region where the GCE VM Instance resides. Defaults to the Google provider's region if nothing is specified here. See https://cloud.google.com/compute/docs/regions-zones"
}

variable "vpc_network_name" {
  type        = string
  description = "Virtual Private Cloud in which GCE VM Instance would be created. If you have custom VPC network, supply VPC Network Name."
}

variable "gce_instance_name" {
  type        = string
  description = "A unique name for the GCE resource. Changing this forces a new resource to be created."
}

variable "gce_network_tags" {
  type        = list(string)
  default     = []
  description = "A list of network tags to attach to the instance."
}

variable "project" {
  type        = string
  description = "GCP Project ID"
}
