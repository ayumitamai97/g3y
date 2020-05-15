# frozen_string_literal: true

module Elasticsearch
  class BaseService
    def initialize
      @logger = Logger.new(STDOUT)
      @client = Elasticsearch::Model.client
      @concerns = [UserAndPostSearchable, RelationshipSearchable]
      @existing_indices = @client.indices.stats.dig('indices')&.keys&.map(&:to_s)
    end
  end
end
