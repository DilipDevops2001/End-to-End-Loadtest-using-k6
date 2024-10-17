provider "google" {
  credentials = file("<path_to_credentials>.json")
  project     = var.project_id
  region      = var.region
}
