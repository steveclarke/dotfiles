# frozen_string_literal: true

require "shale"

module SyncBooks
  module Models
    module FreeAgent
      class Company < Shale::Mapper
        attribute :url, :string
        attribute :name, :string
        attribute :type, :string
        attribute :currency, :string
        attribute :mileage_units, :string
        attribute :company_start_date, :date
        attribute :freeagent_start_date, :date
        attribute :first_accounting_year_end, :date
        attribute :company_registration_number, :string
        attribute :sales_tax_registration_number, :string
        attribute :sales_tax_registration_status, :string
        attribute :sales_tax_effective_date, :date

        def hst_number
          sales_tax_registration_number
        end

        def registered_for_hst?
          sales_tax_registration_status == "Registered"
        end
      end
    end
  end
end
