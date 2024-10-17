provider "google" {
  credentials = file("admin.json")
  project     = var.project_id
  region      = var.region
}
