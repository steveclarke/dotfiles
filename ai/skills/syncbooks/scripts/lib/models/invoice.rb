# frozen_string_literal: true

require "shale"

module SyncBooks
  module Models
    class Invoice < Shale::Mapper
      attribute :url, Shale::Type::String
      attribute :contact, Shale::Type::String
      attribute :contact_name, Shale::Type::String
      attribute :bank_account, Shale::Type::String
      attribute :reference, Shale::Type::String
      attribute :status, Shale::Type::String
      attribute :long_status, Shale::Type::String
      attribute :currency, Shale::Type::String
      attribute :exchange_rate, Shale::Type::Float
      attribute :net_value, Shale::Type::Float
      attribute :sales_tax_value, Shale::Type::Float
      attribute :total_value, Shale::Type::Float
      attribute :paid_value, Shale::Type::Float
      attribute :due_value, Shale::Type::Float
      attribute :dated_on, Shale::Type::Date
      attribute :due_on, Shale::Type::Date
      attribute :paid_on, Shale::Type::Date
      attribute :payment_terms_in_days, Shale::Type::Integer
      attribute :involves_sales_tax, Shale::Type::Boolean
      attribute :send_reminder_emails, Shale::Type::Boolean
      attribute :send_thank_you_emails, Shale::Type::Boolean
      attribute :send_new_invoice_emails, Shale::Type::Boolean
      attribute :omit_header, Shale::Type::Boolean
      attribute :always_show_bic_and_iban, Shale::Type::Boolean
      attribute :created_at, Shale::Type::Time
      attribute :updated_at, Shale::Type::Time

      def id
        url&.split("/")&.last
      end

      def contact_id
        contact&.split("/")&.last
      end

      def open?
        status == "Open"
      end

      def overdue?
        status == "Overdue"
      end

      def paid?
        status == "Paid"
      end

      def draft?
        status == "Draft"
      end

      def outstanding?
        open? || overdue?
      end

      def display_total
        "$#{"%.2f" % (total_value || 0)}"
      end

      def display_due
        "$#{"%.2f" % (due_value || 0)}"
      end
    end
  end
end
