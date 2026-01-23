# frozen_string_literal: true

require "shale"

module SyncBooks
  module Models
    module FreeAgent
      class Project < Shale::Mapper
        attribute :url, :string
        attribute :contact, :string
        attribute :name, :string
        attribute :status, :string
        attribute :budget, :float
        attribute :budget_units, :string
        attribute :currency, :string
        attribute :billing_period, :string
        attribute :hours_per_day, :float
        attribute :uses_project_invoice_sequence, :boolean
        attribute :normal_billing_rate, :float
        attribute :starts_on, :date
        attribute :ends_on, :date
        attribute :created_at, :time
        attribute :updated_at, :time

        def id
          url&.split("/")&.last
        end

        def contact_id
          contact&.split("/")&.last
        end

        def active?
          status == "Active"
        end

        def completed?
          status == "Completed"
        end

        def hidden?
          status == "Hidden"
        end

        def cancelled?
          status == "Cancelled"
        end

        def display_budget
          return nil unless budget
          "#{budget} #{budget_units}"
        end
      end
    end
  end
end
