# frozen_string_literal: true

require "shale"

module SyncBooks
  module Models
    class Expense < Shale::Mapper
      attribute :url, :string
      attribute :user, :string
      attribute :category, :string
      attribute :description, :string
      attribute :currency, :string
      attribute :gross_value, :float
      attribute :native_gross_value, :float
      attribute :sales_tax_rate, :float
      attribute :sales_tax_value, :float
      attribute :native_sales_tax_value, :float
      attribute :sales_tax_status, :string
      attribute :dated_on, :date
      attribute :receipt_reference, :string
      attribute :created_at, :time
      attribute :updated_at, :time

      def id
        url&.split("/")&.last
      end

      def user_id
        user&.split("/")&.last
      end

      def category_code
        category&.split("/")&.last&.to_i
      end

      # Expense gross values are negative (money owed to user)
      def amount
        (gross_value || 0).abs
      end

      def hst_amount
        (sales_tax_value || 0).abs
      end

      def display_amount
        "$#{"%.2f" % amount}"
      end
    end
  end
end
