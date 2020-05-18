# frozen_string_literal: true

module Types
  class BaseQuery < GraphQL::Schema::Resolver
    DATE_FORMAT = /\d{4}-\d{2}-\d{2}/.freeze

    def self.format_date(date:)
      return if date.blank?

      date.match(DATE_FORMAT)&.to_s || raise(G3ySchema::InvalidQueryError)
    end

    def current_user
      context[:current_user]
    end

    private

    def posts_base_query
      match_klass.new(relation_type: 'post').call
    end

    def match_klass
      ElasticQueries::MatchCondition
    end

    def has_parent_klass
      ElasticQueries::HasParentCondition
    end

    def range_klass
      ElasticQueries::RangeCondition
    end

    def and_clause(*queries)
      return {} if queries.blank? || queries.all?(&:blank?)

      { bool: { must: queries } }
    end
  end
end
