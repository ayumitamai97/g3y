# frozen_string_literal: true

module ElasticQueries
  class HasParentCondition < ElasticQueries::BaseCondition
    def initialize(parent_type:, match_conditions:)
      @parent_type = parent_type
      @match_conditions = match_conditions
    end

    attr_accessor :parent_type, :match_conditions, :conditions

    validates :match_conditions, presence: true
    validate do
      errors.add(:base, 'match_conditions should be an array') unless match_conditions.class == Array

      errors.add(:base, 'match_conditions should be present') if match_conditions.all?(&:blank?)
    end

    def append(*args)
      return self unless args.all? { |arg| arg.instance_of?(Hash) }

      merge_conditions(*args)
      self
    end

    def call
      return if invalid?

      condition
    end

    private

    def merge_conditions(*args)
      @conditions ||= [condition, *args]
    end

    def condition
      {
        has_parent: {
          parent_type: parent_type,
          query: {
            bool: {
              should: match_conditions,
            },
          },
        },
      }
    end
  end
end
