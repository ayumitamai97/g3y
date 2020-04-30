# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :authenticate_user, mutation: Mutations::AuthenticateUser
    field :create_user, mutation: Mutations::CreateUser
  end
end
