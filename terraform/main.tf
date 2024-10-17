provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_network" "vpc_network" {
  name = "load-test-vpc"
}

resource "google_compute_subnetwork" "public_subnet" {
  name          = "public-subnet"
  network       = google_compute_network.vpc_network.name
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
}

resource "google_compute_subnetwork" "private_subnet" {
  name          = "private-subnet"
  network       = google_compute_network.vpc_network.name
  ip_cidr_range = "10.0.2.0/24"
  region        = var.region
}

resource "google_compute_instance" "loadtest_instance" {
  count         = var.instance_count
  name          = "loadtest-instance-${count.index}"
  machine_type  = "e2-medium"
  zone          = element(var.zones, count.index % length(var.zones))
  tags          = ["loadtest"]
  
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.public_subnet.name
    access_config {}  # Assigns a public IP
  }

  metadata_startup_script = <<-EOT
    #! /bin/bash
    sudo apt-get update
    sudo apt-get install -y ansible
  EOT
}

output "instance_ips" {
  value = google_compute_instance.loadtest_instance[*].network_interface[0].access_config[0].nat_ip
}
