# frozen_string_literal: true

module ElasticQueries
  class RangeCondition < ElasticQueries::BaseCondition
    def initialize(field:, gte: nil, lte: nil)
      @field = field
      @gte = gte
      @lte = lte
    end

    attr_accessor :field, :gte, :lte, :conditions

    validates :field, presence: true
    validate do
      errors.add(:base, 'one or both of gte/lte should be given') if [gte, lte].all?(&:blank?)
    end

    def append(*args)
      merge_conditions(*args)
      return self unless args.all? { |arg| arg.instance_of?(Hash) }

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
        range: {
          field => { gte: gte, lte: lte },
        },
      }
    end
  end
end
