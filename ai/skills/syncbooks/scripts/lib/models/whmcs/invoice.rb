# frozen_string_literal: true

require "shale"

module SyncBooks
  module Models
    module WHMCS
      class Invoice < Shale::Mapper
        attribute :id, :integer
        attribute :userid, :integer
        attribute :firstname, :string
        attribute :lastname, :string
        attribute :companyname, :string
        attribute :invoicenum, :string
        attribute :date, :string
        attribute :duedate, :string
        attribute :datepaid, :string
        attribute :subtotal, :string
        attribute :credit, :string
        attribute :tax, :string
        attribute :tax2, :string
        attribute :total, :string
        attribute :taxrate, :string
        attribute :taxrate2, :string
        attribute :status, :string
        attribute :paymentmethod, :string
        attribute :notes, :string
        attribute :currencycode, :string
        attribute :currencyprefix, :string
        attribute :currencysuffix, :string
        attribute :created_at, :string
        attribute :updated_at, :string

        def total_value
          total.to_f
        end

        def subtotal_value
          subtotal.to_f
        end

        def tax_value
          tax.to_f
        end

        def client_name
          if companyname && !companyname.empty?
            companyname
          else
            "#{firstname} #{lastname}".strip
          end
        end

        def reference
          invoicenum && !invoicenum.empty? ? invoicenum : id.to_s
        end

        def paid?
          status == "Paid"
        end

        def unpaid?
          status == "Unpaid"
        end

        def cancelled?
          status == "Cancelled"
        end

        def overdue?
          return false unless unpaid?
          return false unless duedate
          Date.parse(duedate) < Date.today
        rescue
          false
        end

        def display_total
          "#{currencyprefix}#{"%.2f" % total_value}#{currencysuffix}"
        end
      end
    end
  end
end
