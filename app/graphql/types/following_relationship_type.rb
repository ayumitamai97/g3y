# frozen_string_literal: true

module Types
  class FollowingRelationshipType < Types::BaseObject
    field :followingId, ID, null: false
    field :followerId, ID, null: false
    field :followingName, String, null: false
    field :followerName, String, null: false
  end
end
