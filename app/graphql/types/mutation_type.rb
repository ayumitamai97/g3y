# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_session, mutation: Mutations::CreateSession
    field :create_user, mutation: Mutations::CreateUser
  end
end
