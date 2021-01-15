dependency "api_management" {
  config_path = "../api_management"
}

# Internal
dependency "resource_group" {
  config_path = "../../../resource_group"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

terraform {
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_api_management_api?ref=v2.1.11"
}

inputs = {
  name                  = "io-backoffice-api"
  resource_group_name   = dependency.resource_group.outputs.resource_name
  api_management_name   = dependency.api_management.outputs.name
  revision              = "1"
  display_name          = "IO BACKOFFICE API"
  description           = "BACKOFFICE API for IO platform."
  host                  = "api.io.italia.it"
  path                  = "backoffice"
  protocols             = ["http","https"]
  swagger_json_template = file("swagger.json.tmpl")
  policy_xml            = file("policy.xml")

  subscription_required = false

}
