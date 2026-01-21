# frozen_string_literal: true

require "shale"

module SyncBooks
  module Models
    class Contact < Shale::Mapper
      attribute :url, :string
      attribute :organisation_name, :string
      attribute :first_name, :string
      attribute :last_name, :string
      attribute :email, :string
      attribute :country, :string
      attribute :status, :string
      attribute :locale, :string
      attribute :account_balance, :float
      attribute :charge_sales_tax, :string
      attribute :contact_name_on_invoices, :boolean
      attribute :active_projects_count, :integer
      attribute :uses_contact_invoice_sequence, :boolean
      attribute :emails_invoices_automatically, :boolean
      attribute :emails_payment_reminders, :boolean
      attribute :emails_thank_you_notes, :boolean
      attribute :created_at, :time
      attribute :updated_at, :time

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
