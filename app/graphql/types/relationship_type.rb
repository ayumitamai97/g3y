# frozen_string_literal: true

module Types
  class RelationshipType < Types::BaseObject
    field :id, ID, null: false
    field :follower_id, ID, null: false
    field :following_id, ID, null: false
  end
end
