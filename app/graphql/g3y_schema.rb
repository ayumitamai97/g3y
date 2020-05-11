# frozen_string_literal: true

class G3ySchema < GraphQL::Schema
  class InvalidQueryError < StandardError; end

  mutation(Types::MutationType)
  query Types::QueryType

  # Opt in to the new runtime (default in future graphql-ruby versions)
  use GraphQL::Execution::Interpreter
  use GraphQL::Analysis::AST

  # Add built-in connections for pagination
  use GraphQL::Pagination::Connections

  use GraphQL::Execution::Errors

  use GraphQL::Batch

  rescue_from ActiveRecord::RecordNotFound do |_err, _obj, _args, _ctx, field|
    raise GraphQL::ExecutionError, "#{field.type.unwrap.graphql_name} not found"
  end

  rescue_from InvalidQueryError do
    raise GraphQL::ExecutionError, 'The query is invalid'
  end
end
