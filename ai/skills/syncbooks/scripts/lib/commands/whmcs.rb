# frozen_string_literal: true

require "thor"

module SyncBooks
  module Commands
    class WHMCS < Thor
      namespace :whmcs

      def self.exit_on_failure?
        true
      end

      desc "transactions", "List recent transactions"
      option :limit, aliases: "-l", type: :numeric, default: 25, desc: "Number of transactions"
      option :json, type: :boolean, default: false, desc: "Output as JSON"
      def transactions
        txns = client.transactions(limit: options[:limit])

        if options[:json]
          data = txns.map do |t|
            { id: t.id, date: t.date, gateway: t.gateway, description: t.description,
              amount_in: t.amount_in, amount_out: t.amount_out, invoice_id: t.invoiceid }
          end
          puts JSON.pretty_generate(data)
          return
        end

        UI.header("WHMCS Transactions")
        UI.blank

        if txns.empty?
          UI.muted("No transactions found.")
          return
        end

        rows = txns.map do |t|
          [
            t.id,
            t.display_date,
            t.gateway || "-",
            t.description&.slice(0, 30) || "-",
            UI.money(t.net_amount)
          ]
        end
        UI.table(rows, columns: ["ID", "Date", "Gateway", "Description", "Amount"])

        UI.blank
        total_in = txns.sum(&:amount_in)
        total_out = txns.sum(&:amount_out)
        UI.muted("#{txns.length} transactions • In: #{UI.money(total_in)} • Out: #{UI.money(total_out)}")
      end

      desc "invoices", "List invoices"
      option :status, aliases: "-s", desc: "Filter by status: Paid, Unpaid, Cancelled, Refunded"
      option :limit, aliases: "-l", type: :numeric, default: 25, desc: "Number of invoices"
      option :json, type: :boolean, default: false, desc: "Output as JSON"
      def invoices
        invs = client.invoices(status: options[:status], limit: options[:limit])

        if options[:json]
          data = invs.map do |i|
            { id: i.id, reference: i.reference, client: i.client_name, date: i.date,
              due_date: i.duedate, status: i.status, total: i.total_value }
          end
          puts JSON.pretty_generate(data)
          return
        end

        title = options[:status] ? "WHMCS Invoices (#{options[:status]})" : "WHMCS Invoices"
        UI.header(title)
        UI.blank

        if invs.empty?
          UI.muted("No invoices found.")
          return
        end

        rows = invs.map do |i|
          [
            i.id,
            i.reference,
            i.date,
            i.duedate,
            i.status,
            UI.money(i.total_value)
          ]
        end
        UI.table(rows, columns: ["ID", "Number", "Date", "Due", "Status", "Total"])

        UI.blank
        total = invs.sum(&:total_value)
        UI.muted("#{invs.length} invoices • Total: #{UI.money(total)}")
      end

      desc "invoice ID", "Show invoice details"
      def invoice(id)
        inv = client.invoice(id)
        puts JSON.pretty_generate(
          id: inv.id,
          reference: inv.reference,
          client: inv.client_name,
          date: inv.date,
          due_date: inv.duedate,
          status: inv.status,
          subtotal: inv.subtotal_value,
          tax: inv.tax_value,
          total: inv.total_value,
          currency: inv.currencycode,
          payment_method: inv.paymentmethod,
          notes: inv.notes
        )
      end

      desc "clients", "List clients"
      option :search, aliases: "-s", desc: "Search by name/email"
      option :limit, aliases: "-l", type: :numeric, default: 25, desc: "Number of clients"
      option :json, type: :boolean, default: false, desc: "Output as JSON"
      def clients
        cls = client.clients(limit: options[:limit], search: options[:search])

        if options[:json]
          data = cls.map do |c|
            { id: c.id, name: c.name, email: c.email, status: c.status, created: c.datecreated }
          end
          puts JSON.pretty_generate(data)
          return
        end

        UI.header("WHMCS Clients")
        UI.blank

        if cls.empty?
          UI.muted("No clients found.")
          return
        end

        rows = cls.map do |c|
          [c.id, c.name, c.email, c.status]
        end
        UI.table(rows, columns: ["ID", "Name", "Email", "Status"])

        UI.blank
        UI.muted("#{cls.length} clients")
      end

      desc "client ID", "Show client details"
      def client_detail(id)
        c = client.client(id)
        puts JSON.pretty_generate(
          id: c.id,
          name: c.name,
          email: c.email,
          phone: c.phonenumber,
          address: c.full_address,
          status: c.status,
          created: c.datecreated,
          notes: c.notes
        )
      end
      map "client" => :client_detail

      desc "test", "Test WHMCS API connection"
      def test
        print "Testing WHMCS connection... "
        if client.test_connection
          UI.success("Connected!")
          puts ""
          puts "API URL: #{Config.credential("whmcs_api_url")}"
        else
          UI.error("Connection failed")
        end
      end

      private

      def client
        @client ||= WHMCSClient.new
      end
    end
  end
end
