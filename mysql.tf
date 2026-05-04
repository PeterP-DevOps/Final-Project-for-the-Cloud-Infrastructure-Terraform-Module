# Создание кластера MySQL
resource "yandex_mdb_mysql_cluster" "mysql" {
  name        = "netology-mysql"
  environment = "PRESTABLE"
  network_id  = yandex_vpc_network.this.id
  version     = "8.0"

  resources {
    resource_preset_id = "s2.micro"
    disk_type_id       = "network-ssd"
    disk_size          = 10
  }

  backup_window_start {
    hours   = 3
    minutes = 0
  }

  host {
    zone      = var.default_zone
    subnet_id = yandex_vpc_subnet.public.id
  }

  access {
    data_lens = false
    web_sql   = false
  }

  # Привязываем отдельную security group для MySQL
  security_group_ids = [yandex_vpc_security_group.mysql_sg.id]
}

# Создание базы данных внутри кластера
resource "yandex_mdb_mysql_database" "db" {
  cluster_id = yandex_mdb_mysql_cluster.mysql.id
  name       = var.mysql_db_name
}

# Создание пользователя MySQL с правами на базу данных
resource "yandex_mdb_mysql_user" "user" {
  cluster_id = yandex_mdb_mysql_cluster.mysql.id
  name       = var.mysql_username
  password   = var.mysql_password

  permission {
    database_name = yandex_mdb_mysql_database.db.name
    roles         = ["ALL"]
  }
}

# Отдельная security group для MySQL — разрешает доступ только из подсети приложения
resource "yandex_vpc_security_group" "mysql_sg" {
  name       = "mysql-sg"
  network_id = yandex_vpc_network.this.id

  ingress {
    description    = "MySQL from application subnet"
    protocol       = "TCP"
    port           = 3306
    v4_cidr_blocks = var.subnet_cidr
  }

  egress {
    protocol       = "ANY"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
