# frozen_string_literal: true

require "httparty"
require "json"

module SyncBooks
  class WHMCSClient
    def initialize
      load_config!
      raise "WHMCS not configured. Run 'syncbooks setup' first." if @api_url.nil? || @identifier.nil? || @secret.nil?
    end

    def load_config!
      @api_url = Config.credential("whmcs_api_url", fallback_env: "WHMCS_API_URL")
      @identifier = Config.credential("whmcs_identifier", fallback_env: "WHMCS_IDENTIFIER")
      @secret = Config.credential("whmcs_secret", fallback_env: "WHMCS_SECRET")
    end

    # Get recent transactions
    def transactions(limit: 25)
      response = api_call("GetTransactions", limitnum: limit)
      response["transactions"]&.dig("transaction") || []
    end

    # Get invoices
    def invoices(status: nil, limit: 25)
      params = { limitnum: limit }
      params[:status] = status if status
      response = api_call("GetInvoices", **params)
      response["invoices"]&.dig("invoice") || []
    end

    # Get single invoice details
    def invoice(id)
      response = api_call("GetInvoice", invoiceid: id)
      response
    end

    # Get clients
    def clients(limit: 25, search: nil)
      params = { limitnum: limit }
      params[:search] = search if search
      response = api_call("GetClients", **params)
      response["clients"]&.dig("client") || []
    end

    # Get single client details
    def client(id)
      response = api_call("GetClientsDetails", clientid: id, stats: true)
      response
    end

    # Get orders
    def orders(limit: 25, status: nil)
      params = { limitnum: limit }
      params[:status] = status if status
      response = api_call("GetOrders", **params)
      response["orders"]&.dig("order") || []
    end

    # Get products/services for a client
    def client_products(client_id)
      response = api_call("GetClientsProducts", clientid: client_id)
      response["products"]&.dig("product") || []
    end

    # Test connection
    def test_connection
      response = api_call("GetAdminDetails")
      response["result"] == "success"
    rescue
      false
    end

    private

    def api_call(action, **params)
      body = {
        action: action,
        identifier: @identifier,
        secret: @secret,
        responsetype: "json"
      }.merge(params)

      response = HTTParty.post(
        @api_url,
        body: body,
        headers: { "Content-Type" => "application/x-www-form-urlencoded" }
      )

      result = JSON.parse(response.body)

      if result["result"] == "error"
        msg = result["message"]
        if msg&.include?("Invalid IP")
          raise <<~ERROR.strip
            WHMCS API error: #{msg}

            Your IP needs to be whitelisted in WHMCS:
              1. Go to WHMCS Admin → System Settings → General Settings → Security
              2. Add your IP to "API IP Access Restriction"
              3. Or disable IP restriction for this API credential
          ERROR
        else
          raise "WHMCS API error: #{msg}"
        end
      end

      result
    end
  end
end
