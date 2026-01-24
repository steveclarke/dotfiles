# frozen_string_literal: true

require "shale"

module SyncBooks
  module Models
    module FreeAgent
      class Invoice < Shale::Mapper
        attribute :url, :string
        attribute :contact, :string
        attribute :contact_name, :string
        attribute :bank_account, :string
        attribute :reference, :string
        attribute :status, :string
        attribute :long_status, :string
        attribute :currency, :string
        attribute :exchange_rate, :float
        attribute :net_value, :float
        attribute :sales_tax_value, :float
        attribute :total_value, :float
        attribute :paid_value, :float
        attribute :due_value, :float
        attribute :dated_on, :date
        attribute :due_on, :date
        attribute :paid_on, :date
        attribute :written_off_date, :date
        attribute :payment_terms_in_days, :integer
        attribute :involves_sales_tax, :boolean
        attribute :send_reminder_emails, :boolean
        attribute :send_thank_you_emails, :boolean
        attribute :send_new_invoice_emails, :boolean
        attribute :omit_header, :boolean
        attribute :always_show_bic_and_iban, :boolean
        attribute :created_at, :time
        attribute :updated_at, :time

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
end
