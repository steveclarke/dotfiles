# frozen_string_literal: true

require "shale"

module SyncBooks
  module Models
    class Contact < Shale::Mapper
      attribute :url, Shale::Type::String
      attribute :organisation_name, Shale::Type::String
      attribute :first_name, Shale::Type::String
      attribute :last_name, Shale::Type::String
      attribute :email, Shale::Type::String
      attribute :country, Shale::Type::String
      attribute :status, Shale::Type::String
      attribute :locale, Shale::Type::String
      attribute :account_balance, Shale::Type::Float
      attribute :charge_sales_tax, Shale::Type::String
      attribute :contact_name_on_invoices, Shale::Type::Boolean
      attribute :active_projects_count, Shale::Type::Integer
      attribute :uses_contact_invoice_sequence, Shale::Type::Boolean
      attribute :emails_invoices_automatically, Shale::Type::Boolean
      attribute :emails_payment_reminders, Shale::Type::Boolean
      attribute :emails_thank_you_notes, Shale::Type::Boolean
      attribute :created_at, Shale::Type::Time
      attribute :updated_at, Shale::Type::Time

      def id
        url&.split("/")&.last
      end

      def name
        organisation_name || "#{first_name} #{last_name}".strip
      end

      def active?
        status == "Active"
      end

      def display_name
        if organisation_name && !organisation_name.empty?
          organisation_name
        else
          "#{first_name} #{last_name}".strip
        end
      end
    end
  end
end
