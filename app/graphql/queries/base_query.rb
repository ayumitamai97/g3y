# frozen_string_literal: true

module Types
  class BaseQuery < GraphQL::Schema::Resolver
    # methods that should be inherited can go here.
    # like a `current_tenant` method, or methods related
    # to the `context` object
    # include SessionGettable
  end
end
