# frozen_string_literal: true

module Mutations
  class CreateUser < BaseMutation
    # ref. https://graphql-ruby.org/mutations/mutation_classes.html

    field :user, Types::UserType, null: true
    field :errors, [String], null: true

    argument :name, String, required: true
    argument :email, String, required: true
    argument :password, String, required: true

    def resolve(name:, email:, password:)
      user = User.create(name: name, email: email, password: password)

      {
        user: user.persisted? ? user : nil,
        errors: user.errors.full_messages,
      }
    end
  end
end
