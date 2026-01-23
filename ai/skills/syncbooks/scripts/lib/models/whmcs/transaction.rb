# frozen_string_literal: true

require "shale"

module SyncBooks
  module Models
    module WHMCS
      class Transaction < Shale::Mapper
        attribute :id, :integer
        attribute :userid, :integer
        attribute :currency, :integer
        attribute :gateway, :string
        attribute :date, :string
        attribute :description, :string
        attribute :amountin, :string
        attribute :amountout, :string
        attribute :fees, :string
        attribute :rate, :string
        attribute :transid, :string
        attribute :invoiceid, :integer
        attribute :refundid, :integer

        def amount_in
          amountin.to_f
        end

        def amount_out
          amountout.to_f
        end

        def net_amount
          amount_in - amount_out
        end

        def fee_amount
          fees.to_f
        end

        def payment?
          amount_in > 0
        end

        def refund?
          amount_out > 0 || refundid.to_i > 0
        end

        def display_amount
          "$#{"%.2f" % net_amount}"
        end

        def display_date
          date&.split(" ")&.first
        end
      end
    end
  end
end
