# frozen_string_literal: true

require "shale"

module SyncBooks
  module Models
    class BankAccount < Shale::Mapper
      attribute :url, :string
      attribute :name, :string
      attribute :type, :string
      attribute :currency, :string
      attribute :status, :string
      attribute :current_balance, :float
      attribute :opening_balance, :float
      attribute :is_personal, :boolean
      attribute :is_primary, :boolean
      attribute :bank_name, :string
      attribute :account_number, :string
      attribute :sort_code, :string
      attribute :bic, :string
      attribute :bank_code, :string
      attribute :latest_activity_date, :date
      attribute :created_at, :time
      attribute :updated_at, :time

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
