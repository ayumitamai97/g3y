# frozen_string_literal: true

module Types
  class PostType < Types::BaseObject
    field :id, Integer, null: false
    field :user, UserType, null: false
    field :content, String, null: false
  end
end
