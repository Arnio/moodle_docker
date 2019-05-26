resource "null_resource" remoteExecProvisionerWFolder {
  depends_on = ["google_sql_database_instance.instance"]
  count      = 1

  connection {
    host        = "${google_compute_instance.jenkins.*.network_interface.0.access_config.0.nat_ip}"
    type        = "ssh"
    user        = "centos"
    private_key = "${file("${var.private_key_path}")}"
    agent       = "false"
  }

  provisioner "file" {
    source      = "${var.private_key_path}"
    destination = "/home/centos/.ssh/id_rsa"
  }

  provisioner "remote-exec" {
    inline = ["sudo chmod 600 /home/centos/.ssh/id_rsa"]
  }

  provisioner "remote-exec" {
    inline = ["rm -rf /tmp/ansible"]
  }

  provisioner "file" {
    source      = "ansible"
    destination = "/tmp/ansible"
  }

  provisioner "file" {
    content     = "${data.template_file.jenkins_conf.rendered}"
    destination = "/tmp/ansible/files/jenkins.plugins.publish_over_ssh.BapSshPublisherPlugin.xml"
  }

  provisioner "file" {
    content     = "${data.template_file.app_conf.rendered}"
    destination = "/tmp/ansible/kubernetes/config.php"
  }

  provisioner "file" {
    content     = "${data.template_file.job_moodle.rendered}"
    destination = "/tmp/ansible/files/job_moodle.xml"
  }

  provisioner "file" {
    content     = "${data.template_file.job_moodle_ossh.rendered}"
    destination = "/tmp/ansible/files/job_moodle_ossh.xml"
  }

  provisioner "file" {
    content     = "${data.template_file.deployment_moodle.rendered}"
    destination = "/tmp/ansible/kubernetes/deployment-moodle.yml"
  }

  provisioner "file" {
    content     = "${data.template_file.docker-entrypoint.rendered}"
    destination = "/tmp/ansible/kubernetes/docker-entrypoint.sh"
  }

  provisioner "file" {
    content     = "${data.template_file.service-moodle.rendered}"
    destination = "/tmp/ansible/kubernetes/service-moodle.yml"
  }
 }

resource "null_resource" inventoryFileWeb {
  depends_on = ["null_resource.remoteExecProvisionerWFolder"]
  count      = 1

  connection {
    host        = "${google_compute_instance.jenkins.*.network_interface.0.access_config.0.nat_ip}"
    type        = "ssh"
    user        = "centos"
    private_key = "${file("${var.private_key_path}")}"
    agent       = "false"
  }

  provisioner "remote-exec" {
    inline = ["echo ${var.instance_name}\tansible_ssh_host=${element(google_compute_instance.jenkins.*.network_interface.0.network_ip, count.index)}\tansible_user=centos\tansible_ssh_private_key_file=/home/centos/.ssh/id_rsa>>/tmp/ansible/hosts.txt"]
  }
}

resource "null_resource" "ansibleProvision" {
  depends_on = ["null_resource.remoteExecProvisionerWFolder", "null_resource.inventoryFileWeb"]
  count      = 1

  connection {
    host        = "${google_compute_instance.jenkins.*.network_interface.0.access_config.0.nat_ip}"
    type        = "ssh"
    user        = "centos"
    private_key = "${file("${var.private_key_path}")}"
    agent       = "false"
  }

  provisioner "remote-exec" {
    inline = ["sudo sed -i -e 's+#host_key_checking+host_key_checking+g' /etc/ansible/ansible.cfg"]
  }

  provisioner "remote-exec" {
    inline = ["ansible-playbook -i /tmp/ansible/hosts.txt /tmp/ansible/main.yml"]
  }
}
