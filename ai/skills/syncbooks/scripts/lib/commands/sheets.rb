# frozen_string_literal: true

require "thor"

module SyncBooks
  module Commands
    class Sheets < Thor
      namespace :sheets

      def self.exit_on_failure?
        true
      end

      desc "read RANGE", "Read cells from spreadsheet (e.g., 'Main!E2:E10')"
      option :spreadsheet, aliases: "-s", desc: "Spreadsheet ID (overrides default)"
      option :dev, type: :boolean, default: false, desc: "Use dev spreadsheet"
      def read(range)
        data = client(spreadsheet_id: options[:spreadsheet], dev: options[:dev]).read(range)
        values = data["values"] || []

        if values.empty?
          puts "No values found in range: #{range}"
        else
          puts "Values from #{range}:"
          puts "-" * 40
          values.each_with_index do |row, i|
            puts "  Row #{i + 1}: #{row.join(" | ")}"
          end
        end
      end

      desc "write RANGE VALUE", "Write to a cell (e.g., 'Main!E2' '1234.56')"
      option :spreadsheet, aliases: "-s", desc: "Spreadsheet ID (overrides default)"
      option :dev, type: :boolean, default: false, desc: "Use dev spreadsheet"
      option :force, aliases: "-f", type: :boolean, default: false, desc: "Skip production safety check"
      def write(range, value)
        c = client(spreadsheet_id: options[:spreadsheet], dev: options[:dev])

        unless options[:force] || options[:dev]
          raise Thor::Error, <<~ERROR
            SAFETY CHECK FAILED

            Write operations are blocked for production spreadsheet.
            Spreadsheet title: "#{c.title}"

            Use --dev flag to write to dev spreadsheet, or --force to write to production.
          ERROR
        end

        result = c.write(range, value)

        puts "Write successful!"
        puts "  Updated cells: #{result["updatedCells"]}"
        puts "  Updated range: #{result["updatedRange"]}"
      end

      desc "summary", "Show key financial metrics from spreadsheet"
      option :spreadsheet, aliases: "-s", desc: "Spreadsheet ID (overrides default)"
      option :dev, type: :boolean, default: false, desc: "Use dev spreadsheet"
      def summary
        c = client(spreadsheet_id: options[:spreadsheet], dev: options[:dev])

        # Fetch all key cells in one batch
        data = c.read("Main!A2:B11")
        liabilities = data["values"] || []

        data = c.read("Main!D2:E14")
        assets = data["values"] || []

        UI.header("Cash Position Summary")
        UI.blank

        # Liabilities section
        UI.section("Liabilities")
        liab_rows = [
          ["HST Owing", liabilities.dig(0, 1) || "-"],
          ["Payroll Remittance", liabilities.dig(1, 1) || "-"],
          ["Outstanding Bills", liabilities.dig(2, 1) || "-"],
          ["Expenses Due (Steve)", liabilities.dig(7, 1) || "-"],
          ["Expenses Due (Clint)", liabilities.dig(8, 1) || "-"],
          ["TOTAL", liabilities.dig(9, 1) || "-"]
        ]
        UI.table(liab_rows, columns: ["Item", "Amount"])

        UI.blank

        # Position section
        UI.section("Cash Position")
        pos_rows = [
          ["HST Collected", assets.dig(0, 1) || "-"],
          ["HST Reclaimed", assets.dig(1, 1) || "-"],
          ["Available COH", assets.dig(4, 1) || "-"],
          ["Net COH", assets.dig(5, 1) || "-"]
        ]
        UI.table(pos_rows, columns: ["Item", "Amount"])

        UI.blank

        # Receivables section
        UI.section("Receivables")
        recv_rows = [
          ["FA Invoices", assets.dig(7, 1) || "-"],
          ["WHMCS Invoices", assets.dig(8, 1) || "-"],
          ["Total Invoices", assets.dig(9, 1) || "-"],
          ["Potentially Available", assets.dig(10, 1) || "-"],
          ["WIP", assets.dig(11, 1) || "-"],
          ["TOTAL WITH WIP", assets.dig(12, 1) || "-"]
        ]
        UI.table(recv_rows, columns: ["Item", "Amount"])
      end

      # === Granular Update Commands ===

      desc "update:coh", "Update only Available Cash On Hand from FreeAgent"
      option :dev, type: :boolean, default: false, desc: "Use dev spreadsheet"
      def update_coh
        print "Fetching balance from FreeAgent... "
        accounts = fa_client.bank_accounts.select(&:active?)
        balance_total = accounts.sum { |a| a.current_balance || 0 }
        puts UI.money(balance_total)

        c = client(dev: options[:dev])
        c.write("Main!E6", format("%.2f", balance_total))
        UI.success("Updated Main!E6 (Available COH): #{UI.money(balance_total)}")
      end
      map "update:coh" => :update_coh

      desc "update:hst", "Update only HST Collected/Reclaimed from FreeAgent"
      option :dev, type: :boolean, default: false, desc: "Use dev spreadsheet"
      def update_hst
        from_date = Config.hst_period_start.to_s
        to_date = Date.today.to_s
        UI.muted("HST Period: #{from_date} to #{to_date}")
        UI.blank

        hst_charged, hst_reclaimed = calculate_hst_values(from_date, to_date)

        c = client(dev: options[:dev])
        c.write("Main!E2", format("%.2f", hst_charged))
        c.write("Main!E3", format("%.2f", hst_reclaimed))

        UI.success("Updated Main!E2 (HST Collected): #{UI.money(hst_charged)}")
        UI.success("Updated Main!E3 (HST Reclaimed): #{UI.money(hst_reclaimed)}")
        UI.blank
        UI.info("Net HST Owing", UI.money(hst_charged - hst_reclaimed))
      end
      map "update:hst" => :update_hst

      desc "update:receivables", "Update only FA Invoices (open + overdue) from FreeAgent"
      option :dev, type: :boolean, default: false, desc: "Use dev spreadsheet"
      def update_receivables
        print "Fetching open invoices... "
        open_invoices = fa_client.invoices(view: "open")
        open_total = open_invoices.sum { |i| i.total_value || 0 }
        puts "#{open_invoices.length} invoices (#{UI.money(open_total)})"

        print "Fetching overdue invoices... "
        overdue_invoices = fa_client.invoices(view: "overdue")
        overdue_total = overdue_invoices.sum { |i| i.total_value || 0 }
        puts "#{overdue_invoices.length} invoices (#{UI.money(overdue_total)})"

        invoices_total = open_total + overdue_total

        c = client(dev: options[:dev])
        c.write("Main!E9", format("%.2f", invoices_total))
        UI.success("Updated Main!E9 (FA Invoices): #{UI.money(invoices_total)}")
      end
      map "update:receivables" => :update_receivables

      desc "update:bills", "Update only Outstanding Bills (open + overdue) from FreeAgent"
      option :dev, type: :boolean, default: false, desc: "Use dev spreadsheet"
      def update_bills
        print "Fetching open bills... "
        open_bills = fa_client.bills_by_view(view: "open")
        open_total = open_bills.sum { |b| b.total_value || 0 }
        puts "#{open_bills.length} bills (#{UI.money(open_total)})"

        print "Fetching overdue bills... "
        overdue_bills = fa_client.bills_by_view(view: "overdue")
        overdue_total = overdue_bills.sum { |b| b.total_value || 0 }
        puts "#{overdue_bills.length} bills (#{UI.money(overdue_total)})"

        bills_total = open_total + overdue_total

        c = client(dev: options[:dev])
        c.write("Main!B4", format("%.2f", bills_total))
        UI.success("Updated Main!B4 (Outstanding Bills): #{UI.money(bills_total)}")
      end
      map "update:bills" => :update_bills

      desc "update:all", "Update all metrics from FreeAgent (same as 'syncbooks sync')"
      option :dev, type: :boolean, default: false, desc: "Use dev spreadsheet"
      def update_all
        UI.header("Updating All Metrics")
        UI.blank

        invoke :update_hst, [], dev: options[:dev]
        UI.blank
        invoke :update_coh, [], dev: options[:dev]
        UI.blank
        invoke :update_receivables, [], dev: options[:dev]
        UI.blank
        invoke :update_bills, [], dev: options[:dev]

        Config.last_sync = Time.now
        UI.blank
        UI.success("All metrics updated! (#{Time.now.strftime("%Y-%m-%d %H:%M")})")
      end
      map "update:all" => :update_all

      desc "info", "Show spreadsheet info"
      option :spreadsheet, aliases: "-s", desc: "Spreadsheet ID (overrides default)"
      option :dev, type: :boolean, default: false, desc: "Use dev spreadsheet"
      def info
        c = client(spreadsheet_id: options[:spreadsheet], dev: options[:dev])
        data = c.metadata

        puts "Spreadsheet Info"
        puts "=" * 50
        puts ""
        puts "Title: #{data.dig("properties", "title")}"
        puts "ID:    #{c.spreadsheet_id}"
        puts "Dev:   #{c.dev_spreadsheet? ? "Yes" : "No"}"
        puts ""
        puts "Sheets:"
        (data["sheets"] || []).each do |sheet|
          props = sheet["properties"]
          puts "  - #{props["title"]} (ID: #{props["sheetId"]})"
        end
      end

      private

      def client(spreadsheet_id: nil, dev: false)
        @client ||= GoogleSheetsClient.new(spreadsheet_id: spreadsheet_id, dev: dev)
      end

      def fa_client
        @fa_client ||= FreeAgentClient.new
      end

      def calculate_hst_values(from_date, to_date)
        hst_charged = 0.0
        hst_reclaimed = 0.0

        print "Fetching invoices... "
        all_invoices = fa_client.invoices_by_date(from_date: from_date, to_date: to_date)
        # Exclude draft invoices - they haven't been sent yet so no HST is due
        invoices = all_invoices.reject { |i| i.status == "Draft" }
        inv_hst = invoices.sum { |i| i.sales_tax_value || 0 }
        hst_charged += inv_hst
        puts "#{invoices.length} invoices (#{all_invoices.length - invoices.length} drafts excluded)"

        print "Fetching bills... "
        bills = fa_client.bills(from_date: from_date, to_date: to_date)
        bills_hst = bills.sum { |b| (b.sales_tax_value || 0).abs }
        hst_reclaimed += bills_hst
        puts "#{bills.length} bills"

        print "Fetching expenses... "
        expenses = fa_client.expenses(from_date: from_date, to_date: to_date)
        exp_hst = expenses.sum { |e| e.hst_amount }
        hst_reclaimed += exp_hst
        puts "#{expenses.length} expenses"

        print "Fetching bank transactions... "
        accounts = fa_client.bank_accounts.select(&:active?)
        bank_charged = 0.0
        bank_reclaimed = 0.0
        total_txns = 0

        accounts.each do |acc|
          exps = fa_client.bank_transaction_explanations(acc.url, from_date: from_date, to_date: to_date)
          total_txns += exps.length
          exps.each do |e|
            stv = e["sales_tax_value"]
            next unless stv

            val = stv.to_f.abs
            cat = e["category"]&.split("/")&.last.to_i
            if cat < 100
              bank_charged += val
            else
              bank_reclaimed += val
            end
          end
        end
        puts "#{total_txns} transactions"

        hst_charged += bank_charged
        hst_reclaimed += bank_reclaimed

        [hst_charged, hst_reclaimed]
      end
    end
  end
end
