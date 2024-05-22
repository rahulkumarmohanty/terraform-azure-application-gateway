# Define a public IP address for the application gateway with static allocation method and Standard SKU
resource "azurerm_public_ip" "pip" {
  name                = var.app_gw_pip_name     # Variable for the name of the public IP
  resource_group_name = var.resource_group_name # Variable for the resource group name
  location            = var.location            # Variable for the location
  allocation_method   = "Static"                # Static allocation method for the public IP
  sku                 = "Standard"              # Standard SKU for the public IP

  lifecycle {
    ignore_changes = all # Ignore changes to all properties during updates
  }
}

# Define local names for various components of the application gateway
locals {
  backend_address_pool_name      = "${var.application_gateway_name}-beap"
  frontend_port_name             = "${var.application_gateway_name}-feport"
  frontend_ip_configuration_name = "${var.application_gateway_name}-feip"
  http_setting_name              = "${var.application_gateway_name}-be-htst"
  listener_name                  = "${var.application_gateway_name}-httplstn"
  request_routing_rule_name      = "${var.application_gateway_name}-rqrt"
  redirect_configuration_name    = "${var.application_gateway_name}-rdrcfg"
  gateway_ip_configuration_name  = "${var.application_gateway_name}-gic"
}

# Define an Azure Application Gateway with the specified configurations
resource "azurerm_application_gateway" "network" {
  name                = var.application_gateway_name # Variable for the name of the Application Gateway
  resource_group_name = var.resource_group_name      # Variable for the resource group name
  location            = var.location                 # Variable for the location

  timeouts {
    create = "10m" # Timeout for creating the Application Gateway
  }

  # Define SKU details for the Application Gateway
  sku {
    name     = var.application_gateway_sku_name     # Variable for the SKU name of the Application Gateway
    tier     = var.application_gateway_tier_name    # Variable for the tier of the Application Gateway
    capacity = var.application_gateway_sku_capacity # Variable for the capacity of the Application Gateway
  }

  # Define IP configuration for the gateway
  dynamic "gateway_ip_configuration" {
    for_each = var.gateway_ip_configuration
    content {
      name      = lookup(gateway_ip_configuration.value, "name", local.gateway_ip_configuration_name) # Local variable for the name of the gateway IP configuration
      subnet_id = lookup(gateway_ip_configuration.value, "subnet_id", null)                           # Variable for the subnet ID
    }
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.pip.id
  }

  dynamic "ssl_certificate" {
    for_each = var.ssl_certificate
    content {
      name                = lookup(ssl_certificate.value, "name", null)
      data                = lookup(ssl_certificate.value, "data", null)
      password            = lookup(ssl_certificate.value, "password", null)
      key_vault_secret_id = lookup(ssl_certificate.value, "key_vault_secret_id", null)
    }
  }

  dynamic "ssl_profile" {
    for_each = var.ssl_profile
    content {
      name                                 = lookup(ssl_profile.value, "name", null)
      trusted_client_certificate_names     = lookup(ssl_profile.value, "trusted_client_certificate_names", null)
      verify_client_cert_issuer_dn         = lookup(ssl_profile.value, "verify_client_cert_issuer_dn", null)
      verify_client_certificate_revocation = lookup(ssl_profile.value, "verify_client_certificate_revocation", null)
    }
  }

  # Define frontend port configuration dynamically
  dynamic "frontend_port" {
    for_each = var.frontend_port # Variable for the frontend port configuration
    content {
      name = lookup(frontend_port.value, "name", local.frontend_port_name) # Name of the frontend port
      port = lookup(frontend_port.value, "port", 80)                       # Port number
    }
  }

  # Define frontend IP configuration dynamically
  dynamic "frontend_ip_configuration" {
    for_each = var.frontend_ip_configuration # Variable for the frontend IP configuration
    content {
      name                          = lookup(frontend_ip_configuration.value, "name", "${local.frontend_ip_configuration_name}-pvt-ip") # Name of the frontend IP configuration
      private_ip_address            = lookup(frontend_ip_configuration.value, "private_ip_address", null)                               # Private IP address
      private_ip_address_allocation = lookup(frontend_ip_configuration.value, "private_ip_address_allocation", "Dynamic")               # Private IP address allocation method
      subnet_id                     = lookup(frontend_ip_configuration.value, "subnet_id", null)                                        # Subnet ID
      public_ip_address_id          = lookup(frontend_ip_configuration.value, "public_ip_address_id", null)
    }
  }

  # Define backend address pool configuration dynamically
  dynamic "backend_address_pool" {
    for_each = var.backend_address_pool # Variable for the backend address pool configuration
    content {
      name         = lookup(backend_address_pool.value, "name", local.backend_address_pool_name) # Name of the backend address pool
      fqdns        = lookup(backend_address_pool.value, "fqdns", null)                           # FQDNs for the backend pool
      ip_addresses = lookup(backend_address_pool.value, "ip_addresses", null)
    }
  }

  # Define backend HTTP settings dynamically
  dynamic "backend_http_settings" {
    for_each = var.backend_http_settings # Variable for the backend HTTP settings
    content {
      name                                = lookup(backend_http_settings.value, "name", local.http_setting_name)              # Name of the backend HTTP settings
      cookie_based_affinity               = lookup(backend_http_settings.value, "cookie_based_affinity", "Disabled")          # Cookie-based affinity setting
      affinity_cookie_name                = lookup(backend_http_settings.value, "affinity_cookie_name", null)                 # Affinity cookie name
      pick_host_name_from_backend_address = lookup(backend_http_settings.value, "pick_host_name_from_backend_address", false) # Pick host name from backend address
      path                                = lookup(backend_http_settings.value, "path", null)                                 # Path for the backend HTTP settings
      port                                = lookup(backend_http_settings.value, "port", null)                                 # Port for the backend HTTP settings
      probe_name                          = lookup(backend_http_settings.value, "probe_name", null)                           # Probe name for the backend HTTP settings
      protocol                            = lookup(backend_http_settings.value, "protocol", "Http")                           # Protocol for the backend HTTP settings
      request_timeout                     = lookup(backend_http_settings.value, "request_timeout", 60)                        # Request timeout for the backend HTTP settings
      host_name                           = lookup(backend_http_settings.value, "host_name", null)
      dynamic "authentication_certificate" {
        for_each = lookup(backend_http_settings.value, "authentication_certificate", {})
        content {
          name = lookup(authentication_certificate.value, "name", null)
        }
      }
    }
  }

  # Define HTTP listener dynamically
  dynamic "http_listener" {
    for_each = var.http_listener # Variable for the HTTP listener configuration
    content {
      name                           = lookup(http_listener.value, "name", local.listener_name)                                            # Name of the HTTP listener
      frontend_ip_configuration_name = lookup(http_listener.value, "frontend_ip_configuration_name", local.frontend_ip_configuration_name) # Frontend IP configuration name
      frontend_port_name             = lookup(http_listener.value, "frontend_port_name", local.frontend_port_name)                         # Frontend port name
      protocol                       = lookup(http_listener.value, "protocol", "Http")                                                     # Protocol for the HTTP listener
      require_sni                    = lookup(http_listener.value, "require_sni", null)                                                    # Require Server Name Indication (SNI)
      ssl_certificate_name           = lookup(http_listener.value, "ssl_certificate_name", null)                                           # SSL certificate name
      host_name                      = lookup(http_listener.value, "host_name", null)
      host_names                     = lookup(http_listener.value, "host_names", null)
      firewall_policy_id             = lookup(http_listener.value, "firewall_policy_id", null)
      ssl_profile_name               = lookup(http_listener.value, "ssl_profile_name", null)
      dynamic "custom_error_configuration" {
        for_each = lookup(http_listener.value, "custom_error_configuration", {})
        content {
          status_code           = lookup(custom_error_configuration.value, "status_code", null)
          custom_error_page_url = lookup(custom_error_configuration.value, "custom_error_page_url", null)
        }
      }
    }
  }

  dynamic "identity" {
    for_each = var.identity
    content {
      type         = lookup(identity.value, "type", null)
      identity_ids = lookup(identity.value, "identity_ids", null)
    }
  }

  dynamic "url_path_map" {
    for_each = var.url_path_map
    content {
      name                                = lookup(url_path_map.value, "name", null)
      default_backend_address_pool_name   = lookup(url_path_map.value, "default_backend_address_pool_name", null)
      default_backend_http_settings_name  = lookup(url_path_map.value, "default_backend_http_settings_name", null)
      default_redirect_configuration_name = lookup(url_path_map.value, "default_redirect_configuration_name", null)
      default_rewrite_rule_set_name       = lookup(url_path_map.value, "default_rewrite_rule_set_name", null)
      dynamic "path_rule" {
        for_each = lookup(url_path_map.value, "path_rule", {})
        content {
          name                        = lookup(path_rule.value, "name", null)
          paths                       = lookup(path_rule.value, "paths", null)
          backend_address_pool_name   = lookup(path_rule.value, "backend_address_pool_name", null)
          backend_http_settings_name  = lookup(path_rule.value, "backend_http_settings_name", null)
          redirect_configuration_name = lookup(path_rule.value, "redirect_configuration_name", null)
          rewrite_rule_set_name       = lookup(path_rule.value, "rewrite_rule_set_name", null)
          firewall_policy_id          = lookup(path_rule.value, "firewall_policy_id", null)
        }
      }
    }
  }

  # Define request routing rule dynamically
  dynamic "request_routing_rule" {
    for_each = var.request_routing_rule # Variable for the request routing rule configuration
    content {
      name                        = lookup(request_routing_rule.value, "name", local.request_routing_rule_name)   # Name of the request routing rule
      rule_type                   = lookup(request_routing_rule.value, "rule_type", "Basic")                      # Rule type for the request routing rule
      priority                    = lookup(request_routing_rule.value, "priority", 2)                             # Priority for the request routing rule
      http_listener_name          = lookup(request_routing_rule.value, "http_listener_name", local.listener_name) # HTTP listener name for the request routing rule
      backend_address_pool_name   = lookup(request_routing_rule.value, "backend_address_pool_name", local.backend_address_pool_name)
      backend_http_settings_name  = lookup(request_routing_rule.value, "backend_http_settings_name", local.http_setting_name)
      redirect_configuration_name = lookup(request_routing_rule.value, "redirect_configuration_name", null)
      rewrite_rule_set_name       = lookup(request_routing_rule.value, "rewrite_rule_set_name", null)
      url_path_map_name           = lookup(request_routing_rule.value, "url_path_map_name", null)
    }
  }

  dynamic "probe" {
    for_each = var.probe
    content {
      name                                      = lookup(probe.value, "name", "default_probe")
      host                                      = lookup(probe.value, "host", null)
      interval                                  = lookup(probe.value, "interval", null)
      path                                      = lookup(probe.value, "path", null)
      protocol                                  = lookup(probe.value, "protocol", null)
      unhealthy_threshold                       = lookup(probe.value, "unhealthy_threshold", null)
      timeout                                   = lookup(probe.value, "timeout", null)
      port                                      = lookup(probe.value, "port", null)
      pick_host_name_from_backend_http_settings = lookup(probe.value, "pick_host_name_from_backend_http_settings", null)
      minimum_servers                           = lookup(probe.value, "minimum_servers", null)
      dynamic "match" {
        for_each = lookup(probe.value, "match", {})
        content {
          body        = lookup(match.value, "body", null)
          status_code = lookup(match.value, "status_code", null)
        }
      }
    }
  }

  dynamic "waf_configuration" {
    for_each = var.wafs
    content {
      enabled          = lookup(var.wafs.waf1, "waf_enabled", null)
      firewall_mode    = lookup(var.wafs.waf1, "waf_firewall_mode", null)
      rule_set_type    = lookup(var.wafs.waf1, "waf_rule_set_type", null)
      rule_set_version = lookup(var.wafs.waf1, "waf_rule_set_version", null)
    }
  }

  tags = var.tags

  depends_on = [azurerm_public_ip.pip]

  lifecycle {
    ignore_changes = all
  }
}

# Resources and locals are used to define and manage Azure resources within the specified configuration
# These components collectively create an Application Gateway with specified frontend, backend, and routing configurations
