dependency "cdn_profile" {
  config_path = "../../cdn/cdn_profile"
}

dependency "log_analytics_workspace" {
  config_path = "../../../common/log_analytics_workspace"
}

dependency "storage_account" {
  config_path = "../../storage_account_logs"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

terraform {
  #source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_monitor_diagnostic_setting?ref=v0.0.29"
  source = "../../../../../../io-infrastructure-modules-new/azurerm_monitor_diagnostic_setting"
}

inputs = {

  name                       = "cdnprofile"
  target_resource_id         = dependency.cdn_profile.outputs.id
  log_analytics_workspace_id = dependency.log_analytics_workspace.outputs.id

  storage_account_id = dependency.storage_account.outputs.id

  logs = [{
    category = "AzureCdnAccessLog"
    enabled  = true
    retention_policy = {
      days    = 365
      enabled = true
    }
  }]
}