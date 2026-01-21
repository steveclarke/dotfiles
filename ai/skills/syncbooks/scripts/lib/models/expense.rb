# frozen_string_literal: true

require "shale"

module SyncBooks
  module Models
    class Expense < Shale::Mapper
      attribute :url, Shale::Type::String
      attribute :user, Shale::Type::String
      attribute :category, Shale::Type::String
      attribute :description, Shale::Type::String
      attribute :currency, Shale::Type::String
      attribute :gross_value, Shale::Type::Float
      attribute :native_gross_value, Shale::Type::Float
      attribute :sales_tax_rate, Shale::Type::Float
      attribute :sales_tax_value, Shale::Type::Float
      attribute :native_sales_tax_value, Shale::Type::Float
      attribute :sales_tax_status, Shale::Type::String
      attribute :dated_on, Shale::Type::Date
      attribute :receipt_reference, Shale::Type::String
      attribute :created_at, Shale::Type::Time
      attribute :updated_at, Shale::Type::Time

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
