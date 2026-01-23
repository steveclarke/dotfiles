# frozen_string_literal: true

require "json"
require "fileutils"

module SyncBooks
  module Credentials
    CREDENTIALS_PATH = File.expand_path("~/.local/share/syncbooks/credentials.json")

    class << self
      def load_all
        return {} unless File.exist?(CREDENTIALS_PATH)
        JSON.parse(File.read(CREDENTIALS_PATH))
      rescue
        {}
      end

      def get_section(service)
        load_all[service] || {}
      end

      def save_section(service, data)
        creds = load_all
        creds[service] ||= {}
        creds[service].merge!(data)

        FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))
        File.write(CREDENTIALS_PATH, JSON.pretty_generate(creds))
        File.chmod(0o600, CREDENTIALS_PATH)
      end

      def clear_section(service)
        creds = load_all
        creds[service] = {}
        File.write(CREDENTIALS_PATH, JSON.pretty_generate(creds))
      end

      # Load tokens for a service
      def load_tokens(service)
        section = get_section(service)
        {
          access_token: section["access_token"],
          refresh_token: section["refresh_token"],
          token_expiry: section["token_expiry"]
        }
      end

      # Save tokens for a service
      def save_tokens(service, access_token:, refresh_token: nil, expires_in: 3600)
        save_section(service, {
          "access_token" => access_token,
          "refresh_token" => refresh_token,
          "token_expiry" => (Time.now + expires_in).utc.to_s
        }.compact)
      end
    end
  end
end
