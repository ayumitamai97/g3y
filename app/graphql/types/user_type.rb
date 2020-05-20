# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :email, String, null: false
    field :avatarKey, String, null: true
    field :posts, [Types::PostType], null: true
  end
end
