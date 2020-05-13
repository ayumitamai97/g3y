# frozen_string_literal: true

module Types
  class BaseField < GraphQL::Schema::Field
    argument_class Types::BaseArgument

    DATE_FORMAT = /\d{4}-\d{2}-\d{2}/.freeze

    def format_date(date:)
      return if date.blank?

      date.match(DATE_FORMAT)&.to_s || raise(G3ySchema::InvalidQueryError)
    end
  end
end
