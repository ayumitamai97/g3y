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
      elsif kwargs.values.all?(&:blank?)
        errors.add(:base, 'the value of a key/value pair should be present')
      end
    end

    def append(*args)
      return self if invalid?
      return self unless args.all? { |arg| arg.instance_of?(Hash) }

      set_conditions(*args)
      self
    end

    def call
      return if invalid?

      condition
    end

    private

    def set_conditions(*args)
      @conditions ||= [condition, *args]
    end

    def condition
      { match: kwargs }
    end
  end
end
