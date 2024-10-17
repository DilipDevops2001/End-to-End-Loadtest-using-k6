variable "project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "region" {
  type        = string
  default     = "us-central1"
  description = "Region for GCP resources"
}

variable "instance_count" {
  type        = number
  default     = 3
  description = "Number of instances to create"
}
