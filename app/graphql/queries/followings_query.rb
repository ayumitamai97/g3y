# frozen_string_literal: true

module Queries
  class FollowingsQuery < Types::BaseQuery
    type [Types::FollowingRelationshipType], null: false

    argument :followerId, ID, required: false, as: :follower_id
    argument :followerName, String, required: false, as: :follower_name
    argument :page, Integer, required: true
    argument :pagePer, Integer, required: true, as: :page_per

    def resolve(follower_id: nil, follower_name: nil, page:, page_per:)
      query = match_klass.new(follower_name: follower_name)
        .append(match_klass.new(follower_id: follower_id).call)
        .build_or_clause

      query_body = { query: query }.merge(meta(page: page, page_per: page_per))

      Relationship.search(query_body).results
    end


    def meta(page:, page_per:)
      {
        sort: ['_score', { created_at: 'desc' }],
        size: page_per,
        from: page_per * page,
      }
    end
  end
end
