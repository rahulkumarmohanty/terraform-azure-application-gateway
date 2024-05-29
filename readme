# Application Gateway

This Terraform script deploys an Azure Application Gateway with customizable frontend, backend, and routing configurations.

## Prerequisites

Ensure you have the following prerequisites before deploying this Terraform script:

- Terraform CLI installed.

## Variables

### Input Variables

Sure, here are the descriptions for the values mentioned for maps in the `main.tf` file:

| Map Name                       | Description                                                                                                     | Example Values                                                                                                                                                                                                                             |
|--------------------------------|-----------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| gateway_ip_configuration      | Configuration for the gateway IP.                                                                               | `{ name = "ip_config_name", subnet_id = "/subscriptions/subscription_id/resourceGroups/resource_group_name/providers/Microsoft.Network/virtualNetworks/vnet_name/subnets/subnet_name" }`                                                   |
| ssl_certificate               | Configuration for SSL certificates.                                                                             | `{ name = "certificate_name", data = "base64_encoded_certificate_data", password = "certificate_password", key_vault_secret_id = "/subscriptions/subscription_id/resourceGroups/resource_group_name/providers/Microsoft.KeyVault/vaults/vault_name/secrets/secret_name" }` |
| ssl_profile                   | Configuration for SSL profiles.                                                                                 | `{ name = "profile_name", trusted_client_certificate_names = ["certificate_name1", "certificate_name2"], verify_client_cert_issuer_dn = true, verify_client_certificate_revocation = false }`                                          |
| identity                      | Configuration for identity.                                                                                     | `{ type = "type_of_identity", identity_ids = ["identity_id1", "identity_id2"] }`                                                                                                                                                          |
| url_path_map                  | Configuration for URL path maps.                                                                                | `{ name = "map_name", default_backend_address_pool_name = "backend_pool_name", default_backend_http_settings_name = "http_settings_name", default_redirect_configuration_name = "redirect_config_name", default_rewrite_rule_set_name = "rewrite_rule_set_name", path_rule = { name = "path_rule_name", paths = ["/path1", "/path2"], backend_address_pool_name = "backend_pool_name", backend_http_settings_name = "http_settings_name", redirect_configuration_name = "redirect_config_name", rewrite_rule_set_name = "rewrite_rule_set_name", firewall_policy_id = "firewall_policy_id" } }` |
| frontend_port                 | Configuration for frontend ports.                                                                               | `{ name = "port_name", port = 80 }`                                                                                                                                                                                                       |
| frontend_ip_configuration    | Configuration for frontend IP addresses.                                                                        | `{ name = "config_name", private_ip_address = "10.0.0.4", private_ip_address_allocation = "Static", subnet_id = "/subscriptions/subscription_id/resourceGroups/resource_group_name/providers/Microsoft.Network/virtualNetworks/vnet_name/subnets/subnet_name", public_ip_address_id = "/subscriptions/subscription_id/resourceGroups/resource_group_name/providers/Microsoft.Network/publicIPAddresses/ip_address_name" }` |
| http_listener                 | Configuration for HTTP listeners.                                                                               | `{ name = "listener_name", frontend_ip_configuration_name = "config_name", frontend_port_name = "port_name", protocol = "Http", require_sni = false, ssl_certificate_name = "certificate_name", host_name = "hostname", host_names = ["hostname1", "hostname2"], firewall_policy_id = "firewall_policy_id", ssl_profile_name = "profile_name", custom_error_configuration = { status_code = 404, custom_error_page_url = "http://example.com/error_page" } }` |
| backend_http_settings         | Configuration for backend HTTP settings.                                                                        | `{ name = "http_settings_name", cookie_based_affinity = "Disabled", affinity_cookie_name = "cookie_name", pick_host_name_from_backend_address = false, path = "/path", port = 80, probe_name = "probe_name", protocol = "Http", request_timeout = 60, host_name = "hostname", authentication_certificate = { name = "certificate_name" } }`                                                |
| request_routing_rule          | Configuration for request routing rules.                                                                       | `{ name = "rule_name", rule_type = "Basic", priority = 2, http_listener_name = "listener_name", backend_address_pool_name = "backend_pool_name", backend_http_settings_name = "http_settings_name", redirect_configuration_name = "redirect_config_name", rewrite_rule_set_name = "rewrite_rule_set_name", url_path_map_name = "map_name" }` |
| probe                         | Configuration for probes.                                                                                      | `{ name = "probe_name", host = "hostname", interval = 30, path = "/path", protocol = "Http", unhealthy_threshold = 3, timeout = 20, port = 80, pick_host_name_from_backend_http_settings = false, minimum_servers = 2, match = { body = "expected_response_body", status_code = 200 } }`                      |
| backend_address_pool          | Configuration for backend address pools.                                                                       | `{ name = "pool_name", fqdns = ["fqdn1", "fqdn2"], ip_addresses = ["ip1", "ip2"] }`                                                                                                                                                       |
| wafs                          | Configuration for Web Application Firewall (WAF).                                                               | `{ enabled = true, firewall_mode = "Detection", rule_set_type = "OWASP", rule_set_version = "2.2" }`                                                                                                                                      |
| tags                          | Tags for Azure resources.                                                                                      | `{ environment = "Production", owner = "John Doe" }`                                                                                                                                                                                     |

Adjust the descriptions as needed based on your specific usage and requirements.

### Output Variables

- None

## Notes

- Ensure all required input variables are provided before deploying the script.
- Review the execution plan (`terraform plan`) before applying changes.
- Take caution when applying changes to production environments.

## Authors

- [Rahul Kumar Mohanty](rahulkumarmohanty01032001@gmail.com)

## License

This project is licensed under the [License Name] License - see the [LICENSE](LICENSE) file for details.
```
Adjust the `<placeholders>` with actual values and customize the "Authors" and "License" sections according to your project details.