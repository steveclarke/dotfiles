# frozen_string_literal: true

# SyncBooks module namespace
module SyncBooks
  LIB_PATH = File.dirname(__FILE__)
end

# Load all components
require_relative "config"
require_relative "credentials"
require_relative "oauth_server"
require_relative "ui"
require_relative "freeagent_client"
require_relative "google_sheets_client"
require_relative "whmcs_client"
require_relative "models"
require_relative "hst_calculator"
require_relative "commands/auth"
require_relative "commands/sheets"
require_relative "commands/whmcs"
