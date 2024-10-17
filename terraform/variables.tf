variable "project_id" {
  type = string
}

variable "region" {
  type = string
  default = "us-central1"
}

variable "zones" {
  type = list(string)
  default = ["us-central1-a", "us-central1-b", "us-central1-c"]
}

variable "instance_count" {
  type    = number
  default = 3
}
