dependency "cdn_profile" {
  config_path = "../cdn_profile"
}

dependency "storage_account_iopayportal" {
  config_path = "../storage_account_iopayportal"
}

# Common
dependency "resource_group" {
  config_path = "../../resource_group"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

terraform {
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_cdn_endpoint?ref=v3.0.3"
}

inputs = {
  name                = "iopayportal"
  resource_group_name = dependency.resource_group.outputs.resource_name
  profile_name        = dependency.cdn_profile.outputs.resource_name
  origin_host_name    = dependency.storage_account_iopayportal.outputs.primary_web_host

  # allow HTTP, HSTS will make future connections over HTTPS
  is_http_allowed = true

  global_delivery_rule = {

    cache_expiration_action       = []
    cache_key_query_string_action = []
    modify_request_header_action  = []

    # HSTS
    modify_response_header_action = [{
      action = "Overwrite"
      name   = "Strict-Transport-Security"
      value  = "max-age=31536000"
      },
      # Content-Security-Policy (in Report mode)
      {
        action = "Overwrite"
        name   = "Content-Security-Policy"
        value  = "default-src 'self'; connect-src 'self' https://api.io.italia.it https://api-eu.mixpanel.com;"
      },
      {
        action = "Append"
        name   = "Content-Security-Policy"
        value  = "frame-ancestors 'none'; object-src 'none'; frame-src 'self' https://www.google.com; img-src 'self' data:;"
      },
      {
        action = "Append"
        name   = "Content-Security-Policy"
        value  = "script-src 'self' https://www.google.com https://www.gstatic.com"
      }
    ]
  }

  # rewrite HTTP to HTTPS
  delivery_rule_request_scheme_condition = [{
    name         = "EnforceHTTPS"
    order        = 1
    operator     = "Equal"
    match_values = ["HTTP"]

    url_redirect_action = {
      redirect_type = "Found"
      protocol      = "Https"
      hostname      = null
      path          = null
      fragment      = null
      query_string  = null
    }

  }]

}
