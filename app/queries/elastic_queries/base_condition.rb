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

    def build_or_clause(minimum_should_match: nil)
      return {} if invalid?
      return {} if conditions.blank?

      # By Elasticsearch default, minimum_should_match default value
      # varies depend on whether must condition exists or not
      { bool: { should: conditions, minimum_should_match: minimum_should_match } }
    end
  end
end
