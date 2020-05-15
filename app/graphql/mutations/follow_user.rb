# frozen_string_literal: true

module Mutations
  class FollowUser < BaseMutation
    field :following, Types::UserType, null: true
    field :errors, [String], null: true

    argument :followerId, ID, required: false, as: :follower_id
    argument :followingId, ID, required: true, as: :following_id

    def resolve(follower_id: nil, following_id:)
      follower = User.find(follower_id || current_user.id)
      following = User.find(following_id)

      if follower.follow(user: following)
        { following: following, errors: [] }
      else
        { following: nil, errors: follower.errors.full_messages }
      end
    end
  end
end
