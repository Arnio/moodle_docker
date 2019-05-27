data "template_file" "jenkins_conf" {
  template = "${file("${path.module}/templates/jenkins.plugins.publish_over_ssh.BapSshPublisherPlugin.tpl")}"

  vars {
    web0_server = "${element(google_compute_instance.jenkins.*.network_interface.0.network_ip, count.index)}"
    web1_server = "localhost"
  }
}

data "template_file" "app_conf" {
  template   = "${file("${path.module}/templates/config.php.tpl")}"
  depends_on = ["google_sql_database_instance.instance"]

  vars {
    #    db_server = "${google_sql_database_instance.instance.ip_address.0.ip_address}"
    db_server      = "127.0.0.1"
    db_name        = "${var.db_name}"
    db_user        = "${var.user_name}"
    db_pass        = "${var.user_password}"
    global_address = "${google_compute_address.my_address.address}"
    redis_host     = "${google_redis_instance.cache.host}"
  }
}

data "template_file" "job_moodle_ossh" {
  template = "${file("${path.module}/templates/job_moodle_ossh.xml.tpl")}"

  vars {
    project          = "${var.project}"
    location         = "${var.zone}"
    db_user          = "${var.user_name}"
    db_pass          = "${var.user_password}"
    sql_instans_name = "${google_sql_database_instance.instance.name}"
    claster_name     = "${var.claster_name}"
    app_name         = "${var.app_name}"
  }
}

data "template_file" "deployment_moodle" {
  template   = "${file("${path.module}/templates/deployment-moodle.yml.tpl")}"
  depends_on = ["google_sql_database_instance.instance"]

  vars {
    project          = "${var.project}"
    region           = "${var.region}"
    app_name         = "${var.app_name}"
    sql_instans_name = "${google_sql_database_instance.instance.name}"
  }
}

data "template_file" "docker-entrypoint" {
  template = "${file("${path.module}/templates/docker-entrypoint.sh.tpl")}"

  vars {
    db_server      = "127.0.0.1"
    db_name        = "${var.db_name}"
    db_user        = "${var.user_name}"
    db_pass        = "${var.user_password}"
    global_address = "${google_compute_address.my_address.address}"
  }
}

data "template_file" "service-moodle" {
  template = "${file("${path.module}/templates/service-moodle.yml.tpl")}"

  vars {
    lb_ip = "${google_compute_address.my_address.address}"
  }
}
