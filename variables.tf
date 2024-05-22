variable "app_gw_pip_name" {
  description = "Name of the Azure Public IP for Application Gateway"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
}

variable "location" {
  description = "Azure region where the resources will be deployed"
  type        = string
}

variable "application_gateway_name" {
  description = "Name of the Azure Application Gateway"
  type        = string
}

variable "application_gateway_sku_name" {
  description = "Name of the Application Gateway SKU"
  type        = string
}

variable "application_gateway_tier_name" {
  description = "Tier of the Application Gateway SKU"
  type        = string
}

variable "application_gateway_sku_capacity" {
  description = "Capacity of the Application Gateway SKU"
  type        = number
}

variable "subnet_id" {
  description = "ID of the subnet where the Application Gateway will be deployed"
  type        = string
}
variable "gateway_ip_configuration" {
  type    = map(any)
  default = {}
}
variable "ssl_certificate" {
  type    = map(any)
  default = {}
}
variable "ssl_profile" {
  type    = map(any)
  default = {}
}
variable "identity" {
  type    = map(any)
  default = {}
}
variable "url_path_map" {
  type    = map(any)
  default = {}
}
variable "frontend_port" {
  type    = map(any)
  default = {}
}
variable "frontend_ip_configuration" {
  type    = map(any)
  default = {}
}
variable "http_listener" {
  type    = map(any)
  default = {}
}
variable "backend_http_settings" {
  type    = map(any)
  default = {}
}
variable "request_routing_rule" {
  type    = map(any)
  default = {}
}
variable "probe" {
  type    = map(any)
  default = {}
}
variable "backend_address_pool" {
  type    = map(any)
  default = {}
}
variable "wafs" {
  type    = map(any)
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}