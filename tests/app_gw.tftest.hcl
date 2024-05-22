run "application_gateway" {
    command = apply 
    variables {
        resource_group_name = "rg"
        location = "eastus"
        subnet_id = "/subscriptions/d219afde-4945-4d40-b8da-6b692a5adfb4/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/gw_subnet"
        application_gateway_name = "test-agw"
        application_gateway_sku_name = "WAF_v2"
        application_gateway_tier_name = "WAF_v2"
        application_gateway_sku_capacity = 2
        app_gw_pip_name = "pip-test"
        gateway_ip_configuration = {
            "ip_configuration" = {
                name = "gw-ip-conf"
                subnet_id = "/subscriptions/d219afde-4945-4d40-b8da-6b692a5adfb4/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/gw_subnet"
            }
        }
        frontend_port = {
            "port1" = {
                "name" = "feport"
                "port" = 80
            }
        }
        frontend_ip_configuration = {
            "fip1" = {
                "name" = "frontend"
                "private_ip_address" = "10.0.2.10"
                "private_ip_address_allocation" = "Static"
                "subnet_id" = "/subscriptions/d219afde-4945-4d40-b8da-6b692a5adfb4/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/gw_subnet"
            }
        }
        backend_address_pool = {
            "backend2" = {
                "name" = "backend"
                "ip_addresses" = ["10.0.1.4"]
            }
        }
        backend_http_settings = {
            "settings1" = {
                "name" = "backend-http"
                "cookie_based_affinity" = "Disabled"
                "path" = "/"
                "port" = 80
                "pick_host_name_from_backend_address" = true
                "probe_name" = "health-check"
                "protocol" = "Http"
                "request_timeout" = 60
            },
        }
        http_listener = {
            "listener2" = {
                "name" = "listener"
                "frontend_ip_configuration_name" = "frontend"
                "frontend_port_name" = "feport"
                "protocol" ="Http"
                "require_sni" = false
            }
        }
        probe = {
            "probe1" = {
                "name" = "health-check"
                "interval" = 30
                "path" = "/status-0123456789abcdef"
                "protocol" = "Http"
                "unhealthy_threshold" = 3
                "timeout" = 30
                "port" = 80
                "pick_host_name_from_backend_http_settings" = true
                "minimum_servers" = 0
            },
        }
        request_routing_rule = {
            "rule1" = {
                "name" = "https-rule"
                "rule_type" = "Basic"
                "priority" = 1
                "http_listener_name" = "listener"
                "backend_address_pool_name" = "backend"
                "backend_http_settings_name" = "backend-http"
            },
        }
        wafs = {
            "waf1" = {
                waf_enabled = true
                waf_firewall_mode = "Detection"
                waf_rule_set_type = "OWASP"
                waf_rule_set_version = "3.2"
            }
        }

    }
}