# Temp resource gruop to test cosmosdb private endpoints
dependency "resource_group" {
  config_path = "../../resource_group"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

terraform {
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_cosmosdb_account?ref=v2.0.20"
}

inputs = {
  name                = "pltest"
  resource_group_name = dependency.resource_group.outputs.resource_name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  consistency_policy = {
    consistency_level       = "Session"
    max_interval_in_seconds = null
    max_staleness_prefix    = null
  }

  main_geo_location_location = "westeurope"

  is_virtual_network_filter_enabled = false
}