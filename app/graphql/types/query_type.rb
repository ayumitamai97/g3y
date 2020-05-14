# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :user, UserType, null: false do
      argument :id, ID, required: false
      argument :name, String, required: false
    end
    field :post, PostType, null: false do
      argument :id, ID, required: true
    end
    field :followings, [UserType], null: false do
      argument :followerId, ID, required: true, as: :follower_id
    end
    field :posts, resolver: Queries::PostsQuery
    field :fuzzy_posts, resolver: Queries::FuzzyPostsQuery

    def user(id: nil, name: nil)
      User.find(id)
    rescue ActiveRecord::RecordNotFound
      User.find_by!(name: name)
    end

    def post(id:)
      Post.find(id)
    end

    def followings(follower_id:)
      # TODO: pagination
      User.find(follower_id).followings
    end
  end
end
