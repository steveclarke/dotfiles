# frozen_string_literal: true

require "shale"

require_relative "models/freeagent"
require_relative "models/whmcs"

module SyncBooks
  module Models
    # Parse a collection of JSON objects into model instances
    def self.parse_collection(json_array, model_class)
      return [] if json_array.nil? || json_array.empty?
      json_array.map { |item| model_class.from_hash(item) }
    end
  end
end
