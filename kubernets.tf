resource "google_container_cluster" "primary" {
  name     = "${var.claster_name}"
  location = "${var.zone}"

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = "${google_compute_network.my_vpc_network.name}"
  subnetwork = "${google_compute_subnetwork.private_subnetwork.name}"

  ip_allocation_policy {
    cluster_secondary_range_name  = "${google_compute_subnetwork.private_subnetwork.secondary_ip_range.0.range_name}"
    services_secondary_range_name = "${google_compute_subnetwork.private_subnetwork.secondary_ip_range.1.range_name}"
  }

    # Setting an empty username and password explicitly disables basic auth
    master_auth {
      username = ""
      password = ""
    }
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.claster_name}-pool"
  location   = "${google_container_cluster.primary.location}"
  cluster    = "${google_container_cluster.primary.name}"
  node_count = 2

  node_config {
    preemptible  = true
    machine_type = "n1-standard-2"

    metadata {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring"
    ]
  }
}
