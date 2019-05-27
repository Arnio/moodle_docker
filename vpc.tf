resource "google_compute_network" "my_vpc_network" {
  name                    = "my-vpc-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "private_subnetwork" {
  name          = "private-subnetwork"
  ip_cidr_range = "${var.ip_cidr_range_private}"
  region        = "${var.region}"
  network       = "${google_compute_network.my_vpc_network.self_link}"

  secondary_ip_range {
    range_name    = "secondary-subnetwork"
    ip_cidr_range = "${var.ip_cidr_range_secondary}"
  }

  secondary_ip_range {
    range_name    = "service-subnetwork"
    ip_cidr_range = "${var.ip_cidr_range_service}"
  }

  private_ip_google_access = true
}

resource "google_compute_address" "my_address" {
  name   = "ip-external-address"
  region = "${var.region}"
}

resource "google_compute_firewall" "ssh_firewall" {
  name    = "allow-ssh"
  network = "${google_compute_network.my_vpc_network.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  source_tags   = ["ssh"]
}

resource "google_compute_firewall" "web_firewall" {
  name    = "allow-web"
  network = "${google_compute_network.my_vpc_network.name}"

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = ["0.0.0.0/0"]
  source_tags   = ["web"]
}
