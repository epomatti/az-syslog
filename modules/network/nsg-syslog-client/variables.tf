variable "workload" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "compute_subnet_id" {
  type = string
}

variable "allowed_source_address_prefixes" {
  type = list(string)
}

variable "syslog_network_interface_id" {
  type = string
}
