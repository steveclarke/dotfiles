# frozen_string_literal: true

require "shale"

module SyncBooks
  module Models
    module FreeAgent
      class Bill < Shale::Mapper
        attribute :url, :string
        attribute :contact, :string
        attribute :contact_name, :string
        attribute :reference, :string
        attribute :status, :string
        attribute :long_status, :string
        attribute :currency, :string
        attribute :net_value, :float
        attribute :sales_tax_value, :float
        attribute :total_value, :float
        attribute :paid_value, :float
        attribute :due_value, :float
        attribute :native_due_value, :float
        attribute :dated_on, :date
        attribute :due_on, :date
        attribute :paid_on, :date
        attribute :comments, :string
        attribute :is_locked, :boolean
        attribute :locked_reason, :string
        attribute :input_total_values_inc_tax, :boolean
        attribute :is_paid_by_hire_purchase, :boolean
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
