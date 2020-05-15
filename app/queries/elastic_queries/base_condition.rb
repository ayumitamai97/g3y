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

      # minimum_should_match default value varies depend on whether must condition exists or not
      { bool: { should: conditions } }
    end
  end
end
