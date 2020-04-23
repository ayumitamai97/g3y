# frozen_string_literal: true

module Elasticsearch
  class CreateIndicesService < BaseService
    def execute
      @concerns.each do |concern|
        concern.create_index! unless @existing_indices.include?(concern::INDEX_NAME.to_s)
      rescue StandardError => e
        next @logger.error(e)
      end
    end
  end
end
