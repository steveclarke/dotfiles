# frozen_string_literal: true

require "httparty"
require "uri"

module SyncBooks
  class GoogleSheetsClient
    BASE_URL = "https://sheets.googleapis.com/v4/spreadsheets"
    AUTH_URL = "https://accounts.google.com/o/oauth2/v2/auth"
    TOKEN_URL = "https://oauth2.googleapis.com/token"
    SCOPES = "https://www.googleapis.com/auth/spreadsheets"

    attr_reader :spreadsheet_id

    def initialize(spreadsheet_id: nil, dev: false)
      @spreadsheet_id = spreadsheet_id || load_spreadsheet_id(dev: dev)
      load_config!
      raise "Google Sheets not configured. Run 'syncbooks auth sheets' first." if @access_token.nil? || @access_token.empty?
    end

    def load_config!
      tokens = Credentials.load_tokens("google_sheets")
      @access_token = tokens[:access_token]
      @refresh_token = tokens[:refresh_token]
      @token_expiry = tokens[:token_expiry]

      @client_id = Config.credential("google_client_id", fallback_env: "SYNCBOOKS_GOOGLE_CLIENT_ID")
      @client_secret = Config.credential("google_client_secret", fallback_env: "SYNCBOOKS_GOOGLE_CLIENT_SECRET")

      @access_token ||= ENV["SYNCBOOKS_GOOGLE_API_KEY"]
      @refresh_token ||= ENV["SYNCBOOKS_GOOGLE_REFRESH_TOKEN"]
    end

    def load_spreadsheet_id(dev:)
      key = dev ? "spreadsheet_id_dev" : "spreadsheet_id"
      id = Config.credential(key)
      raise "Spreadsheet ID not configured. Run 'syncbooks setup' first." unless id
      id
    end

    # Read values from a range
    def read(range)
      encoded_range = URI.encode_www_form_component(range)
      get("/#{@spreadsheet_id}/values/#{encoded_range}")
    end

    # Write values to a range
    def write(range, values)
      encoded_range = URI.encode_www_form_component(range)
      body = {values: values.is_a?(Array) ? values : [[values]]}
      put("/#{@spreadsheet_id}/values/#{encoded_range}?valueInputOption=USER_ENTERED", body)
    end

    # Get spreadsheet metadata
    def metadata(fields: "properties.title,sheets.properties")
      get("/#{@spreadsheet_id}?fields=#{fields}")
    end

    # Get spreadsheet title
    def title
      data = metadata(fields: "properties.title")
      data.dig("properties", "title")
    end

    # Check if this is a dev spreadsheet
    def dev_spreadsheet?
      title&.downcase&.include?("(dev)")
    end

    private

    def get(endpoint, retry_count: 0)
      response = HTTParty.get("#{BASE_URL}#{endpoint}", headers: auth_headers)
      result = handle_response(response, retry_count: retry_count)
      return get(endpoint, retry_count: retry_count + 1) if result == :retry
      result
    end

    def put(endpoint, body, retry_count: 0)
      response = HTTParty.put(
        "#{BASE_URL}#{endpoint}",
        headers: auth_headers.merge("Content-Type" => "application/json"),
        body: body.to_json
      )
      result = handle_response(response, retry_count: retry_count)
      return put(endpoint, body, retry_count: retry_count + 1) if result == :retry
      result
    end

    def auth_headers
      {"Authorization" => "Bearer #{@access_token}"}
    end

    def handle_response(response, retry_count: 0)
      return response.parsed_response if response.success?

      if response.code == 401 && can_refresh? && retry_count == 0
        refresh_token!
        return :retry
      end

      error = response.parsed_response&.dig("error", "message") || response.body
      raise "Google Sheets API error: #{response.code} - #{error}"
    end

    def can_refresh?
      @refresh_token && @client_id && @client_secret
    end

    def refresh_token!
      response = HTTParty.post(
        TOKEN_URL,
        headers: {"Content-Type" => "application/x-www-form-urlencoded"},
        body: {
          grant_type: "refresh_token",
          refresh_token: @refresh_token,
          client_id: @client_id,
          client_secret: @client_secret
        }
      )

      if response.success?
        data = response.parsed_response
        @access_token = data["access_token"]
        @refresh_token = data["refresh_token"] if data["refresh_token"]

        Credentials.save_tokens("google_sheets",
          access_token: @access_token,
          refresh_token: @refresh_token,
          expires_in: data["expires_in"] || 3600
        )
      else
        raise "Failed to refresh Google token: #{response.body}"
      end
    end
  end
end
