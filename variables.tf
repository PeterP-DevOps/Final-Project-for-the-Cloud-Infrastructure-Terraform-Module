variable "yc_token" {
  type      = string
  sensitive = true
}

variable "cloud_id" {
  type = string
}

variable "folder_id" {
  type = string
}

variable "default_zone" {
  type    = string
  default = "ru-central1-a"
}

variable "public_key_path" {
  type = string
}

variable "vm_user" {
  type    = string
  default = "ubuntu"
}

variable "vm_name" {
  type    = string
  default = "web-01"
}

variable "vm_platform_id" {
  type    = string
  default = "standard-v3"
}

variable "vm_cores" {
  type    = number
  default = 2
}

variable "vm_memory" {
  type    = number
  default = 2
}

variable "vm_core_fraction" {
  type    = number
  default = 20
}

variable "subnet_cidr" {
  type    = list(string)
  default = ["10.10.1.0/24"]
}

variable "mysql_db_name" {
  type    = string
  default = "appdb"
}

variable "mysql_username" {
  type    = string
  default = "appuser"
}

variable "mysql_password" {
  type      = string
  sensitive = true
}

variable "app_image" {
  type        = string
  description = "Полный URL образа в Container Registry"
}

variable "registry_name" {
  type    = string
  default = "netology-registry"
}
