output "instance_id" {
  description = "Unique id of Google Cloud Spanner Instance."
  value       = local.instance_id
}

output "instance_display_name" {
  description = "Display name of Google Cloud Spanner Instance."
  value       = local.instance_display_name
}

output "dbname" {
  description = "Database name created in Google Cloud Spanner."
  value       = local.dbname
}

output "ddl_queries" {
  description = "DDL being created in Google Cloud Spanner DB"
  value       = var.ddl_queries
}

output "labels_var" {
  description = "Labels of created Google Cloud Spanner Instance."
  value       = var.labels_var
}
