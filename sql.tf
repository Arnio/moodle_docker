data "null_data_source" "auth_mysql_allowed_1" {
  count = "${var.countnat}"

  inputs = {
    name  = "address-${count.index + 1}"
    value = "${element(google_compute_address.my_address.*.address, count.index)}"
  }
}

resource "random_id" "db_name_id" {
  byte_length = 4
}

resource "google_sql_database_instance" "instance" {
  name             = "${var.db_instance_name}-master-${random_id.db_name_id.hex}"
  region           = "${var.region}"
  database_version = "${var.database_version}"

  settings {
    tier              = "${var.db_tier}"
    disk_autoresize   = "${var.disk_autoresize}"
    disk_size         = "${var.disk_size}"
    disk_type         = "${var.disk_type}"
    activation_policy = "ALWAYS"
    availability_type = "ZONAL"
    replication_type  = "SYNCHRONOUS"
#    database_flags    = ["${var.database_flags}"]
    ip_configuration {
      ipv4_enabled = "true"

      authorized_networks = [
        "${data.null_data_source.auth_mysql_allowed_1.*.outputs}",
      ]
    }

    # backup_configuration {
    #   binary_log_enabled = true
    #   enabled            = true
    #   start_time         = "02:30" # every 2:30AM
    # }
  }
}

# resource "google_sql_database_instance" "instance_sql_replica" {
#   name                 = "${var.db_instance_name}-replica-${random_id.db_name_id.hex}"
#   region               = "${var.region}"
#   database_version     = "${var.database_version}"
#   master_instance_name = "${google_sql_database_instance.instance.name}"

#   replica_configuration {
#     connect_retry_interval = "60"
#     failover_target = true
#   }

#   settings {
#     tier                   = "${var.db_tier}"
#     disk_autoresize        = "${var.disk_autoresize}"
#     disk_size              = "${var.disk_size}"
#     disk_type              = "${var.disk_type}"
#     crash_safe_replication = true
#   }
# }

resource "google_sql_database" "default" {
  name      = "${var.db_name}"
  project   = "${var.project}"
  instance  = "${google_sql_database_instance.instance.name}"
  charset   = "${var.db_charset}"
  collation = "${var.db_collation}"
}

resource "google_sql_user" "default" {
  name     = "${var.user_name}"
  project  = "${var.project}"
  instance = "${google_sql_database_instance.instance.name}"
  host     = "${var.user_host}"
  password = "${var.user_password}"
}
