data "template_file" "cloudinit" {
  template = file("${path.module}/templates/cloud-init.yml.tpl")
  vars = {
    vm_user        = var.vm_user
    ssh_key        = file(var.public_key_path)
    app_image      = var.app_image
    mysql_host     = yandex_mdb_mysql_cluster.mysql.host[0].fqdn
    mysql_port     = 3306
    mysql_db       = yandex_mdb_mysql_database.db.name
    mysql_user     = yandex_mdb_mysql_user.user.name
    mysql_password = var.mysql_password
  }
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

resource "yandex_compute_instance" "vm" {
  name        = var.vm_name
  platform_id = var.vm_platform_id
  zone        = var.default_zone

  resources {
    cores         = var.vm_cores
    memory        = var.vm_memory
    core_fraction = var.vm_core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 15
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.web_sg.id]
  }

  metadata = {
    user-data = data.template_file.cloudinit.rendered
  }
}
