cloud_run_service_name       = "omegatrade-backend"
backend_container_image_path = "gcr.io/[PROJECT_NAME]/[APP]:[TAG]"
cloud_run_region             = "us-west1"
cloud_run_env_var = {
  "INSTANCE"   = "[ENTER-SPANNER-INSTANCE-NAME]",
  "DATABASE"   = "[ENTER-SPANNER-DATABASE-NAME]",
  "EXPIRE_IN"  = "2d",
  "JWT_SECRET" = "w54p3Y?4dj%8Xqa2jjVC84narhe5Pk",
  "PROJECTID"  = "[ENTER-GCP-PROJECT-ID]"
}
project = "[ENTER-GCP-PROJECT-ID]"
