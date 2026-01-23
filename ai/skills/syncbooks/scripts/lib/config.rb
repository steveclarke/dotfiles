# frozen_string_literal: true

require "json"
require "date"
require "fileutils"

module SyncBooks
  class Config
    CONFIG_PATH = File.expand_path("~/.config/syncbooks/config.json")

    # 1Password references for setup
    OP_REFS = {
      "freeagent_client_id" => "op://Employee/FreeAgent API - SyncBooks/username",
      "freeagent_client_secret" => "op://Employee/FreeAgent API - SyncBooks/credential",
      "google_client_id" => "op://Employee/Google Sheets API - SyncBooks/client id",
      "google_client_secret" => "op://Employee/Google Sheets API - SyncBooks/client secret",
      "spreadsheet_id" => "op://Employee/Google Sheets API - SyncBooks/cash-on-hand-sheet-id",
      "spreadsheet_id_dev" => "op://Employee/Google Sheets API - SyncBooks/cash-on-hand-sheet-id-dev",
      "whmcs_api_url" => "op://Employee/WHMCS API - SyncBooks Daily Accounting/API URL",
      "whmcs_identifier" => "op://Employee/WHMCS API - SyncBooks Daily Accounting/identifier",
      "whmcs_secret" => "op://Employee/WHMCS API - SyncBooks Daily Accounting/secret"
    }.freeze

    class << self
      def load
        return {} unless File.exist?(CONFIG_PATH)
        JSON.parse(File.read(CONFIG_PATH))
      rescue
        {}
      end

      def save(config)
        FileUtils.mkdir_p(File.dirname(CONFIG_PATH))
        File.write(CONFIG_PATH, JSON.pretty_generate(config))
      end

      def get(key)
        load[key]
      end

      def set(key, value)
        config = load
        config[key] = value
        save(config)
      end

      # Fetch all static credentials from 1Password and cache them
      def setup!(quiet: false)
        config = load

        OP_REFS.each do |key, ref|
          puts "  Fetching #{key}..." unless quiet
          result = `op read '#{ref}' 2>/dev/null`.chomp
          if result.empty?
            raise "Failed to fetch #{key} from 1Password (#{ref})"
          end
          config[key] = result
        end

        save(config)
        config
      end

      # Check if setup has been run
      def setup_complete?
        config = load
        OP_REFS.keys.all? { |key| config[key] && !config[key].empty? }
      end

      # Get cached credential, or fetch from 1Password if not cached
      def credential(key, fallback_env: nil)
        # First try config cache
        value = get(key)
        return value if value && !value.empty?

        # Fall back to environment variable
        if fallback_env
          value = ENV[fallback_env]
          return value if value && !value.empty?
        end

        # Finally try 1Password (and warn about it)
        ref = OP_REFS[key]
        if ref
          warn "Config not set up. Run 'syncbooks setup' to cache credentials."
          warn "Fetching #{key} from 1Password..."
          result = `op read '#{ref}' 2>/dev/null`.chomp
          return result unless result.empty?
        end

        nil
      end

      # HST period helpers
      def hst_period_start
        date_str = get("hst_period_start")
        date_str ? Date.parse(date_str) : current_quarter_start
      end

      def hst_period_start=(date)
        set("hst_period_start", date.to_s)
      end

      def current_quarter_start
        today = Date.today
        quarter_month = ((today.month - 1) / 3) * 3 + 1
        Date.new(today.year, quarter_month, 1)
      end

      def next_quarter_start(from_date = nil)
        from_date ||= hst_period_start
        month = from_date.month + 3
        year = from_date.year
        if month > 12
          month -= 12
          year += 1
        end
        Date.new(year, month, 1)
      end

      def quarter_name(date)
        quarter = ((date.month - 1) / 3) + 1
        "Q#{quarter} #{date.year}"
      end

      # Last sync tracking
      def last_sync
        ts = get("last_sync")
        ts ? Time.parse(ts) : nil
      end

      def last_sync=(time)
        set("last_sync", time.utc.iso8601)
      end
    end
  end
end
