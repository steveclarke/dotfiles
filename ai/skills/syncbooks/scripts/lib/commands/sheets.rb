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
    end
  end
end
