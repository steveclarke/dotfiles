# frozen_string_literal: true

require "shale"

module SyncBooks
  module Models
    class BankAccount < Shale::Mapper
      attribute :url, Shale::Type::String
      attribute :name, Shale::Type::String
      attribute :type, Shale::Type::String
      attribute :currency, Shale::Type::String
      attribute :status, Shale::Type::String
      attribute :current_balance, Shale::Type::Float
      attribute :opening_balance, Shale::Type::Float
      attribute :is_personal, Shale::Type::Boolean
      attribute :is_primary, Shale::Type::Boolean
      attribute :bank_name, Shale::Type::String
      attribute :account_number, Shale::Type::String
      attribute :sort_code, Shale::Type::String
      attribute :bic, Shale::Type::String
      attribute :bank_code, Shale::Type::String
      attribute :latest_activity_date, Shale::Type::Date
      attribute :created_at, Shale::Type::Time
      attribute :updated_at, Shale::Type::Time

      def id
        url&.split("/")&.last
      end

      def active?
        status == "active"
      end

      def credit_card?
        type == "CreditCardAccount"
      end

      def bank?
        type == "StandardBankAccount"
      end

      def paypal?
        type&.include?("Paypal")
      end

      def display_balance
        "$#{"%.2f" % (current_balance || 0)}"
      end
    end
  end
end
