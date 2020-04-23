# frozen_string_literal: true

module Elasticsearch
  class DeleteIndicesService < BaseService
    def execute
      @concerns.each do |concern|
        @client.indices.delete(index: concern::INDEX_NAME.to_s) if @existing_indices.include?(concern::INDEX_NAME.to_s)
      rescue StandardError => e
        next @logger.error(e)
      end
    end
  end
end
