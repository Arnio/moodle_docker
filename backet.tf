terraform {
  backend "gcs" {
    bucket      = "tf-moodle-stage"
    prefix      = "terraform"
    credentials = "ansible/.ssh/gcp_devops.json"
  }
}
