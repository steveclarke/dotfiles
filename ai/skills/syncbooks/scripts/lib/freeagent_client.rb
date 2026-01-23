# frozen_string_literal: true

require "httparty"
require "uri"

module SyncBooks
  class FreeAgentClient
    BASE_URL = "https://api.freeagent.com/v2"
    TOKEN_URL = "https://api.freeagent.com/v2/token_endpoint"

    def initialize
      load_config!
      raise "FreeAgent not configured. Run 'syncbooks auth fa' first." if @access_token.nil? || @access_token.empty?
    end

    def load_config!
      tokens = Credentials.load_tokens("freeagent")
      @access_token = tokens[:access_token]
      @refresh_token = tokens[:refresh_token]
      @token_expiry = tokens[:token_expiry]

      @client_id = Config.credential("freeagent_client_id", fallback_env: "FREEAGENT_CLIENT_ID")
      @client_secret = Config.credential("freeagent_client_secret", fallback_env: "FREEAGENT_CLIENT_SECRET")

      @access_token ||= ENV["FREEAGENT_API_KEY"]
      @refresh_token ||= ENV["FREEAGENT_REFRESH_TOKEN"]
    end

    # Contacts
    def contacts(view: "active")
      data = get("/contacts?view=#{view}")["contacts"] || []
      parse_collection(data, Models::Contact)
    end

    def contact(id)
      data = get("/contacts/#{id}")["contact"]
      Models::Contact.from_hash(data)
    end

    def create_contact(attrs)
      data = post("/contacts", {contact: attrs})["contact"]
      Models::Contact.from_hash(data)
    end

    def find_contact_by_name(name)
      contacts.find { |c| c.name&.downcase == name.downcase }
    end

    # Invoices
    def invoices(view: "recent", nested_invoice_items: true)
      params = "view=#{view}&nested_invoice_items=#{nested_invoice_items}"
      data = get("/invoices?#{params}")["invoices"] || []
      parse_collection(data, Models::Invoice)
    end

    def invoice(id)
      data = get("/invoices/#{id}")["invoice"]
      Models::Invoice.from_hash(data)
    end

    def create_invoice(attrs)
      data = post("/invoices", {invoice: attrs})["invoice"]
      Models::Invoice.from_hash(data)
    end

    def mark_invoice_sent(id)
      put("/invoices/#{id}/transitions/mark_as_sent", {})
    end

    def invoices_by_date(from_date:, to_date:)
      data = get_all_pages("/invoices?from_date=#{from_date}&to_date=#{to_date}")
      parse_collection(data, Models::Invoice)
    end

    # Bills
    def bills(from_date:, to_date:)
      data = get_all_pages("/bills?from_date=#{from_date}&to_date=#{to_date}")
      parse_collection(data, Models::Bill)
    end

    def bills_by_view(view:)
      data = get("/bills?view=#{view}")["bills"] || []
      parse_collection(data, Models::Bill)
    end

    # Expenses
    def expenses(from_date:, to_date:)
      data = get_all_pages("/expenses?from_date=#{from_date}&to_date=#{to_date}")
      parse_collection(data, Models::Expense)
    end

    # Bank accounts
    def bank_accounts
      data = get("/bank_accounts")["bank_accounts"] || []
      parse_collection(data, Models::BankAccount)
    end

    def bank_transaction_explanations(bank_account_url, from_date:, to_date:)
      encoded_url = URI.encode_www_form_component(bank_account_url)
      get_all_pages("/bank_transaction_explanations?bank_account=#{encoded_url}&from_date=#{from_date}&to_date=#{to_date}")
    end

    # Projects
    def projects(contact_id: nil)
      url = "/projects"
      url += "?contact=#{BASE_URL}/contacts/#{contact_id}" if contact_id
      data = get(url)["projects"] || []
      parse_collection(data, Models::Project)
    end

    # Company
    def company
      data = get("/company")["company"]
      Models::Company.from_hash(data)
    end

    private

    def parse_collection(data, model_class)
      return [] if data.nil? || data.empty?
      data.map { |item| model_class.from_hash(item) }
    end

    def get_all_pages(endpoint)
      all_items = []
      page = 1
      loop do
        sep = endpoint.include?("?") ? "&" : "?"
        url = "#{endpoint}#{sep}page=#{page}&per_page=100"
        response = get(url)
        items = response.values.find { |v| v.is_a?(Array) }
        break if items.nil? || items.empty?
        all_items.concat(items)
        break if items.length < 100
        page += 1
        break if page > 50
      end
      all_items
    end

    def get(endpoint, retry_count: 0)
      response = HTTParty.get("#{BASE_URL}#{endpoint}", headers: auth_headers)
      result = handle_response(response, retry_count: retry_count)
      return get(endpoint, retry_count: retry_count + 1) if result == :retry
      result
    end

    def post(endpoint, body, retry_count: 0)
      response = HTTParty.post(
        "#{BASE_URL}#{endpoint}",
        headers: auth_headers.merge("Content-Type" => "application/json"),
        body: body.to_json
      )
      result = handle_response(response, retry_count: retry_count)
      return post(endpoint, body, retry_count: retry_count + 1) if result == :retry
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

      raise "FreeAgent API error: #{response.code} - #{response.body}"
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

        Credentials.save_tokens("freeagent",
          access_token: @access_token,
          refresh_token: @refresh_token,
          expires_in: data["expires_in"] || 3600
        )
      else
        raise "Failed to refresh FreeAgent token: #{response.body}"
      end
    end
  end
end
