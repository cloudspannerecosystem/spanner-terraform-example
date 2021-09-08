## --- REQUIRED PARAMETERS ------------------------------------------------------------------------------------------------

variable "suffix" {
  description = "An arbitrary suffix that will be added to the end of the resource name(s). For example: an environment name, a business-case name, a numeric id, etc."
  type        = string
  validation {
    condition     = length(var.suffix) <= 14
    error_message = "A max of 14 character(s) are allowed."
  }
}

variable "instance_id" {
  type        = string
  description = "A unique identifier for the instance, which cannot be changed after the instance is created."
}

variable "dbname" {
  type        = string
  description = "A unique identifier for the database, which cannot be changed after the instance is created."
}

variable "project" {
  type        = string
  description = "GCP Project ID"
}

variable "config" {
  type        = string
  description = "Cloud Spanner Instance config - Regional / multi-region. For allowed configurations, check: https://cloud.google.com/spanner/docs/instances#available-configurations-regional"
}

variable "num_nodes" {
  type        = number
  description = "The number of nodes allocated to this instance. Comment num_nodes and uncomment processing_units if want to go with processing units, instead of node counts."
}

# variable "processing_units" {
#   type        = number
#   description = "The number of processing units allocated to this instance."
# }

## --- OPTIONAL PARAMETERS ------------------------------------------------------------------------------------------------

variable "instance_display_name" {
  type        = string
  default     = ""
  description = "The descriptive name for this instance as it appears in UIs. Must be unique per project and between 4 and 30 characters in length."
}

variable "labels_var" {
  type        = map(string)
  default     = {}
  description = "Labels to inject into the spanner instance."
}

variable "ddl_queries" {
  type = list(string)
  default = [
    "CREATE TABLE users (userId STRING(36) NOT NULL, businessEmail STRING(50), fullName STRING(36), password STRING(100), photoUrl STRING(250), provider STRING(20), forceChangePassword BOOL) PRIMARY KEY(userId)",
    "CREATE UNIQUE NULL_FILTERED INDEX usersByBusinessEmail ON users (businessEmail)",
    "CREATE TABLE companies (companyId STRING(36) NOT NULL, companyName STRING(30), companyShortCode STRING(15), created_at TIMESTAMP NOT NULL OPTIONS (allow_commit_timestamp=true)) PRIMARY KEY(companyId)",
    "CREATE UNIQUE NULL_FILTERED INDEX companiesByCompanyName ON companies (companyName)",
    "CREATE UNIQUE NULL_FILTERED INDEX companiesByShortCode ON companies (companyShortCode)",
    "CREATE TABLE companyStocks (companyStockId STRING(36) NOT NULL, companyId STRING(36) NOT NULL, open NUMERIC, volume NUMERIC, currentValue NUMERIC, date FLOAT64, close NUMERIC, dayHigh NUMERIC, dayLow NUMERIC, timestamp TIMESTAMP NOT NULL OPTIONS (allow_commit_timestamp=true), CONSTRAINT FK_CompanyStocks FOREIGN KEY (companyId) REFERENCES companies (companyId)) PRIMARY KEY(companyStockId)",
    "CREATE TABLE simulations (sId STRING(36) NOT NULL, companyId STRING(36) NOT NULL, status STRING(36), createdAt TIMESTAMP NOT NULL OPTIONS (allow_commit_timestamp=true), CONSTRAINT FK_CompanySimulation FOREIGN KEY (companyId) REFERENCES companies (companyId)) PRIMARY KEY(sId)",
  ]
  description = "An optional list of DDL statements to run inside the newly created database. Statements can create tables, indexes, etc."
}
variable "deletion_protection" {
  type        = bool
  default     = false
  description = "Whether or not to allow Terraform to destroy the instance."
}

variable "spanner_instance_timeout" {
  type        = string
  default     = "10m"
  description = "How long a Google Spanner Instance creation operation is allowed to take before being considered a failure."
}

variable "spanner_db_timeout" {
  type        = string
  default     = "6m"
  description = "How long a Google Spanner Instance DB creation operation is allowed to take before being considered a failure."
}
