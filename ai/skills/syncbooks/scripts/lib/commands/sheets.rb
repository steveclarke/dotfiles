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

        puts "Cash Position Summary"
        puts "=" * 50
        puts ""

        # Liabilities section (column A-B)
        puts "LIABILITIES"
        puts "-" * 50
        puts format("  %-30s %15s", "HST Owing:", liabilities.dig(0, 1) || "-")
        puts format("  %-30s %15s", "Payroll Remittance:", liabilities.dig(1, 1) || "-")
        puts format("  %-30s %15s", "Outstanding Bills:", liabilities.dig(2, 1) || "-")
        puts format("  %-30s %15s", "Expenses Due (Steve):", liabilities.dig(7, 1) || "-")
        puts format("  %-30s %15s", "Expenses Due (Clint):", liabilities.dig(8, 1) || "-")
        puts "-" * 50
        puts format("  %-30s %15s", "TOTAL LIABILITIES:", liabilities.dig(9, 1) || "-")
        puts ""

        # Assets section (column D-E)
        puts "POSITION"
        puts "-" * 50
        puts format("  %-30s %15s", "HST Collected:", assets.dig(0, 1) || "-")
        puts format("  %-30s %15s", "HST Reclaimed:", assets.dig(1, 1) || "-")
        puts ""
        puts format("  %-30s %15s", "Available COH:", assets.dig(4, 1) || "-")
        puts format("  %-30s %15s", "Net COH:", assets.dig(5, 1) || "-")
        puts ""
        puts format("  %-30s %15s", "FA Invoices:", assets.dig(7, 1) || "-")
        puts format("  %-30s %15s", "WHMCS Invoices:", assets.dig(8, 1) || "-")
        puts format("  %-30s %15s", "Total Invoices:", assets.dig(9, 1) || "-")
        puts ""
        puts format("  %-30s %15s", "Potentially Available:", assets.dig(10, 1) || "-")
        puts format("  %-30s %15s", "WIP:", assets.dig(11, 1) || "-")
        puts "=" * 50
        puts format("  %-30s %15s", "TOTAL WITH WIP:", assets.dig(12, 1) || "-")
        puts "=" * 50
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
