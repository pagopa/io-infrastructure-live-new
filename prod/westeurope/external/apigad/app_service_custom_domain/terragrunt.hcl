dependency "app_service" {
  config_path = "../app_service"
}

// External
dependency "resource_group" {
  config_path = "../../resource_group"
}

dependency "app_service_certificate" {
  config_path = "../app_service_certificate"
}

# Infra
dependency "dns_zone" {
  config_path = "../../../infra/public_dns_zone"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

terraform {
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_app_service_custom_domain?ref=v3.0.3"
}

inputs = {
  name                = "apigad"
  resource_group_name = dependency.resource_group.outputs.resource_name

  custom_domain = {
    name                     = "api-gad"
    zone_name                = dependency.dns_zone.outputs.name
    zone_resource_group_name = dependency.dns_zone.outputs.resource_group_name
    certificate_thumbprint   = dependency.app_service_certificate.outputs.thumbprint
  }

  ssl_state             = "IpBasedEnabled"
  app_service_name      = dependency.app_service.outputs.name
  default_site_hostname = dependency.app_service.outputs.default_site_hostname
}
