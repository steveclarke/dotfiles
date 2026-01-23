# frozen_string_literal: true

require "thor"
require "httparty"
require "uri"

module SyncBooks
  module Commands
    class Auth < Thor
      namespace :auth

      def self.exit_on_failure?
        true
      end

      desc "fa", "Authenticate with FreeAgent"
      option :clear, type: :boolean, default: false, desc: "Clear stored credentials"
      def fa
        if options[:clear]
          Credentials.clear_section("freeagent")
          puts "FreeAgent credentials cleared."
          return
        end

        client_id = Config.credential("freeagent_client_id")
        client_secret = Config.credential("freeagent_client_secret")

        unless client_id && client_secret
          raise Thor::Error, "Credentials not configured. Run 'syncbooks setup' first."
        end

        puts "FreeAgent OAuth Configuration"
        puts "=" * 50
        puts ""

        auth_url = "https://api.freeagent.com/v2/approve_app?response_type=code&client_id=#{URI.encode_www_form_component(client_id)}&redirect_uri=#{URI.encode_www_form_component(OAuthServer::REDIRECT_URI)}"

        puts "Step 1: Opening browser for authorization..."
        puts ""
        puts "If the browser doesn't open, visit:"
        puts auth_url
        puts ""

        system("open", auth_url) if RUBY_PLATFORM.include?("darwin")

        puts "Step 2: Waiting for authorization callback..."
        puts "(Listening on #{OAuthServer::REDIRECT_URI})"
        puts ""

        code = OAuthServer.wait_for_callback

        unless code
          raise Thor::Error, "Authorization failed or timed out."
        end

        puts "Authorization code received."
        puts ""
        puts "Step 3: Exchanging code for access tokens..."
        puts ""

        response = HTTParty.post(
          "https://api.freeagent.com/v2/token_endpoint",
          headers: {"Content-Type" => "application/x-www-form-urlencoded"},
          body: {
            grant_type: "authorization_code",
            code: code,
            client_id: client_id,
            client_secret: client_secret,
            redirect_uri: OAuthServer::REDIRECT_URI
          }
        )

        unless response.success?
          raise Thor::Error, "Token exchange failed: #{response.body}"
        end

        data = response.parsed_response
        Credentials.save_tokens("freeagent",
          access_token: data["access_token"],
          refresh_token: data["refresh_token"],
          expires_in: data["expires_in"] || 3600
        )

        puts "FreeAgent OAuth configured successfully!"
        puts "Run 'syncbooks balance' to verify the connection."
      end

      desc "sheets", "Authenticate with Google Sheets"
      option :clear, type: :boolean, default: false, desc: "Clear stored credentials"
      def sheets
        if options[:clear]
          Credentials.clear_section("google_sheets")
          puts "Google Sheets credentials cleared."
          return
        end

        client_id = Config.credential("google_client_id")
        client_secret = Config.credential("google_client_secret")

        unless client_id && client_secret
          raise Thor::Error, "Credentials not configured. Run 'syncbooks setup' first."
        end

        puts "Google Sheets OAuth Configuration"
        puts "=" * 50
        puts ""

        auth_params = {
          client_id: client_id,
          redirect_uri: OAuthServer::REDIRECT_URI,
          response_type: "code",
          scope: GoogleSheetsClient::SCOPES,
          access_type: "offline",
          prompt: "consent"
        }
        auth_url = "#{GoogleSheetsClient::AUTH_URL}?#{URI.encode_www_form(auth_params)}"

        puts "Step 1: Opening browser for authorization..."
        puts ""
        puts "If the browser doesn't open, visit:"
        puts auth_url
        puts ""

        system("open", auth_url) if RUBY_PLATFORM.include?("darwin")

        puts "Step 2: Waiting for authorization callback..."
        puts "(Listening on #{OAuthServer::REDIRECT_URI})"
        puts ""

        code = OAuthServer.wait_for_callback

        unless code
          raise Thor::Error, "Authorization failed or timed out."
        end

        puts "Authorization code received."
        puts ""
        puts "Step 3: Exchanging code for access tokens..."
        puts ""

        response = HTTParty.post(
          GoogleSheetsClient::TOKEN_URL,
          headers: {"Content-Type" => "application/x-www-form-urlencoded"},
          body: {
            grant_type: "authorization_code",
            code: code,
            client_id: client_id,
            client_secret: client_secret,
            redirect_uri: OAuthServer::REDIRECT_URI
          }
        )

        unless response.success?
          raise Thor::Error, "Token exchange failed: #{response.body}"
        end

        data = response.parsed_response
        Credentials.save_tokens("google_sheets",
          access_token: data["access_token"],
          refresh_token: data["refresh_token"],
          expires_in: data["expires_in"] || 3600
        )

        puts "Google Sheets OAuth configured successfully!"
        puts "Run 'syncbooks sheets info' to verify the connection."
      end
    end
  end
end
