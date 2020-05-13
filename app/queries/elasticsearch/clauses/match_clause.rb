module Elasticsearch
  module Clauses
    class MatchClause
      def initialize(**kwargs)
        @conditions = kwargs.map { |k,v| [k, [v].flatten] }.to_h
      end

      attr_accessor :conditions

      def call
        #{ match: hash }
      end

      # def or(**or_conditions)
      #   merged_conditions = conditions.map { |k,v|
      #     v << or_conditions[k]
      #     [:match, { k => v }]
      #   }.to_h
      #   OrClause.new(merged_conditions)
      # end
    end
  end
end


