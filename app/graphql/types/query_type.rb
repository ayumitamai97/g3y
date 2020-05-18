# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.
    field :posts, resolver: Queries::PostsQuery
    field :fuzzy_posts, resolver: Queries::FuzzyPostsQuery
    field :followings, resolver: Queries::FollowingsQuery

    field :relationship, RelationshipType, null: true do
      argument :follower_id, ID, required: false, as: :follower_id
      argument :following_id, ID, required: true, as: :following_id
    end

    def relationship(follower_id: nil, following_id:)
      Relationship.find_by(follower_id: follower_id || current_user.id, following_id: following_id)
    end
  end
end
