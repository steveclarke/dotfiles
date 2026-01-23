# frozen_string_literal: true

require "gum"

module SyncBooks
  module UI
    PRIMARY = "#7D56F4"
    SUCCESS = "#28a745"
    ERROR = "#dc3545"
    WARNING = "#ffc107"

    class << self
      # Styled header with border
      def header(text)
        puts Gum.style(
          " #{text} ",
          foreground: PRIMARY,
          bold: true,
          border: :rounded,
          border_foreground: PRIMARY,
          padding: "0 1"
        )
      end

      # Section header (no border, just bold)
      def section(text)
        puts Gum.style(text, foreground: PRIMARY, bold: true)
      end

      # Pretty table
      def table(rows, columns:)
        return if rows.empty?
        Gum.table(
          rows,
          columns: columns,
          print: true,
          border: :rounded,
          header_foreground: PRIMARY,
          separator: "\t"
        )
      end

      # Success message
      def success(text)
        puts Gum.style("✓ #{text}", foreground: SUCCESS)
      end

      # Error message
      def error(text)
        puts Gum.style("✗ #{text}", foreground: ERROR)
      end

      # Warning message
      def warning(text)
        puts Gum.style("⚠ #{text}", foreground: WARNING)
      end

      # Muted/subtle text
      def muted(text)
        puts Gum.style(text, faint: true)
      end

      # Info line (key: value)
      def info(key, value)
        puts "#{Gum.style("#{key}:", bold: true)} #{value}"
      end

      # Format money
      def money(amount, currency: "CAD")
        formatted = "$#{format("%.2f", amount)}"
        amount < 0 ? Gum.style(formatted, foreground: ERROR) : formatted
      end

      # Divider line
      def divider
        puts Gum.style("─" * 50, faint: true)
      end

      # Blank line
      def blank
        puts ""
      end
    end
  end
end
