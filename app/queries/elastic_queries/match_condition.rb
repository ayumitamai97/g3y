# frozen_string_literal: true

module ElasticQueries
  class MatchCondition < ElasticQueries::BaseCondition
    def initialize(**kwargs)
      @kwargs = kwargs
    end

    attr_accessor :kwargs, :conditions

    validates :kwargs, presence: true
    validate do
      if kwargs.keys.count > 1
        errors.add(:base, 'kwargs should be exactly one key/value pair')
      elsif kwargs.values.all?(&:blank?) && conditions&.blank?
        errors.add(:base, 'the value of a key/value pair should be present')
      end
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
      @conditions ||= [condition, *args].compact
    end

    def condition
      { match: kwargs.compact.presence }.compact.presence
    end
  end
end
