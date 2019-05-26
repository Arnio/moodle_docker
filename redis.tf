resource "google_redis_instance" "cache" {
  name = "moodle-redis-cache"
  tier = "BASIC"

  memory_size_gb = 1

  location_id = "${var.zone}"

  //alternative_location_id = "us-central1-f"

  authorized_network = "${google_compute_network.my_vpc_network.name}"
  redis_version      = "REDIS_4_0"
  display_name       = "Terraform Test Instance"

  // reserved_ip_range = "192.168.0.0/29"

  labels = {
    my_key    = "my_val"
    other_key = "other_val"
  }
}
