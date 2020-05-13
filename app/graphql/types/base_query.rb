# frozen_string_literal: true

module Types
  class BaseQuery < GraphQL::Schema::Resolver
    DATE_FORMAT = /\d{4}-\d{2}-\d{2}/.freeze

    def self.format_date(date:)
      return if date.blank?

      date.match(DATE_FORMAT)&.to_s || raise(G3ySchema::InvalidQueryError)
    end
  end
end
