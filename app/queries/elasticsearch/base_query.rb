# frozen_string_literal: true

module Elasticsearch
  class BaseQuery
    include ActiveModel::Model
    include ActiveModel::Validations

    def initialize(**params)
      params.each do |k, v|
        public_send(:"#{k}=", v.presence)
      end
    end

    attr_accessor :page, :page_per

    validates :page, :page_per, presence: true

    def call
      raise NotImplementedError
    end

    private

    def body(query:)
      {
        query: query&.deep_stringify_keys,
        sort: { created_at: 'desc' }, size: page_per, from: page_per * page,
      }
    end

    def parent_id(child_type:, parent_id:)
      { parent_id: { type: child_type, id: parent_id } }
    end

    def match(hash)
      { match: hash }
    end

    def range(created_at_after: nil, created_at_before: nil)
      return if [created_at_after, created_at_before].all?(&:blank?)

      {
        range: {
          created_at: {
            gte: created_at_after.presence,
            lte: created_at_before.presence,
          },
        },
      }
    end

    # Example:
    # {
    #   bool: {
    #     must: {
    #       [
    #         { match: { content: 'and_1' } },
    #         { match: { content: 'and_2' } },
    #         { match: { content: 'or_1 or_2' } },
    #         { parent_id: { type: child_type, id: parent_id } }
    #       ]
    #     }
    #   }
    # }

    def and_condition(queries)
      { bool: { must: queries } }
    end

    def or_condition(queries)
      { bool: { should: queries }, minimum_should_match: 1 }
    end
  end
end
