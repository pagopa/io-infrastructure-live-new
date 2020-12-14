dependency "public_ip" {
  config_path = "../../../appgateway/public_ip"
}

# siem
/*
dependency "resource_group_siem" {
  config_path = "../../../../siem/resource_group"
}

dependency "event_hub_siem" {
  config_path = "../../../../siem/event_hub"
}
*/

dependency "log_analytics_workspace" {
  config_path = "../../../../common/log_analytics_workspace"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

terraform {
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_monitor_diagnostic_setting?ref=v2.1.0"
}

inputs = {
  name                       = "pip-appgateway"
  target_resource_id         = dependency.public_ip.outputs.id
  log_analytics_workspace_id = dependency.log_analytics_workspace.outputs.id

  /*
  eventhub_name                = dependency.event_hub_siem.outputs.name[1]
  eventhub_namespace_name      = dependency.event_hub_siem.outputs.eventhub_namespace_name
  eventhub_authorization_rule  = "RootManageSharedAccessKey"
  eventhub_resource_group_name = dependency.resource_group_siem.outputs.resource_name
  */

  logs = [{
    category = "DDoSProtectionNotifications"
    enabled  = true
    retention_policy = {
      days    = null
      enabled = false
    }
    },
    {
      category = "DDoSMitigationFlowLogs"
      enabled  = true
      retention_policy = {
        days    = null
        enabled = false
      }
    },
    {
      category = "DDoSMitigationReports"
      enabled  = false
      retention_policy = {
        days    = null
        enabled = false
      }
  }]

  metrics = [{
    category = "AllMetrics"
    enabled  = false
    retention_policy = {
      days    = null
      enabled = false
    }
  }]
}
