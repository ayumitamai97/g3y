module Elasticsearch
  module Clauses
    class OrClause
      def initialize(**kwargs)
        @conditions = kwargs.
          map { |k,v| [k, [v].flatten] }.
          map { |k, vs| vs.map { |v| [k,v] } }.
          flatten(1)
      end

      attr_accessor :conditions

      # def call
      #   {
      #     bool: {
      #       should: @conditions
      #     },
      #     minimum_should_match: 1,
      #   }
      # end
    end
  end
end
