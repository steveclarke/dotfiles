# frozen_string_literal: true

require "shale"

module SyncBooks
  module Models
    module WHMCS
      class Client < Shale::Mapper
        attribute :id, :integer
        attribute :firstname, :string
        attribute :lastname, :string
        attribute :companyname, :string
        attribute :email, :string
        attribute :datecreated, :string
        attribute :groupid, :integer
        attribute :status, :string

        # Additional fields from GetClientsDetails
        attribute :address1, :string
        attribute :address2, :string
        attribute :city, :string
        attribute :state, :string
        attribute :postcode, :string
        attribute :country, :string
        attribute :phonenumber, :string
        attribute :currency, :integer
        attribute :notes, :string

        def name
          if companyname && !companyname.empty?
            companyname
          else
            "#{firstname} #{lastname}".strip
          end
        end

        def display_name
          name
        end

        def active?
          status == "Active"
        end

        def inactive?
          status == "Inactive"
        end

        def closed?
          status == "Closed"
        end

        def full_address
          parts = [address1, address2, city, state, postcode, country].compact.reject(&:empty?)
          parts.join(", ")
        end
      end
    end
  end
end
