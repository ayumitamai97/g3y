# frozen_string_literal: true

module ElasticQueries
  class BaseCondition
    include ActiveModel::Model
    include ActiveModel::Validations

    def call
      raise NotImplementedError
    end

    def append(*args)
      raise NotImplementedError
    end

    def condition
      raise NotImplementedError
    end

    def build_or_clause
      return if invalid?
      return if conditions.blank?

      { bool: { should: conditions, minimum_should_match: 1 } }
    end
  end
end
