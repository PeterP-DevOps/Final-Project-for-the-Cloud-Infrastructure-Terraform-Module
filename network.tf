resource "yandex_vpc_network" "this" {
  name = "netology-vpc"
}

resource "yandex_vpc_subnet" "public" {
  name           = "public-subnet-a"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.this.id
  v4_cidr_blocks = var.subnet_cidr
}
