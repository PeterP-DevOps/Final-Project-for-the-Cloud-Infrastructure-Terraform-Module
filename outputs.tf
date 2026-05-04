output "vm_external_ip" {
  value = yandex_compute_instance.vm.network_interface[0].nat_ip_address
}

output "container_registry_id" {
  value = yandex_container_registry.registry.id
}

output "container_registry_name" {
  value = yandex_container_registry.registry.name
}

output "mysql_fqdn" {
  value = yandex_mdb_mysql_cluster.mysql.host[0].fqdn
}
