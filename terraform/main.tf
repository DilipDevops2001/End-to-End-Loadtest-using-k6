resource "google_compute_network" "vpc_network" {
  name = "loadtest-network"
}

resource "google_compute_subnetwork" "subnetwork" {
  name          = "loadtest-subnet"
  region        = var.region
  network       = google_compute_network.vpc_network.self_link
  ip_cidr_range = "10.0.0.0/16"
}

resource "google_compute_instance" "loadtest_instance" {
  count         = var.instance_count
  name          = "k6-loadtest-instance-${count.index + 1}"
  machine_type  = "e2-medium"
  zone          = "${var.region}-a"
  tags          = ["http-server"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.self_link
    subnetwork = google_compute_subnetwork.subnetwork.self_link
    access_config {
      // Ephemeral public IP
    }
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y k6
  EOT
}
