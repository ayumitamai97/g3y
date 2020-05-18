# frozen_string_literal: true

module Queries
  class FollowingsQuery < Types::BaseQuery
    type [Types::FollowingRelationshipType], null: false

    argument :followerId, ID, required: false, as: :follower_id
    argument :followerName, String, required: false, as: :follower_name
    argument :followingName, String, required: false, as: :following_name
    argument :page, Integer, required: true
    argument :pagePer, Integer, required: true, as: :page_per

    def resolve(follower_id: nil, follower_name: nil, following_name: nil, page:, page_per:)
      query_body = {
        query: query(
          follower_id: follower_id || current_user&.id,
          follower_name: follower_name || current_user&.name,
          following_name: following_name
        ),
      }.merge(meta(page: page, page_per: page_per))

      Relationship.search(query_body).results
    end

    private

    def query(follower_id: nil, follower_name: nil, following_name: nil)
      or_condition = match_klass.new(follower_name: follower_name)
                                .append(match_klass.new(follower_id: follower_id).call)
                                .build_or_clause

      and_condition = and_clause(match_klass.new(following_name: following_name).call)

      or_condition.merge(and_condition) { |_key, or_c, and_c| or_c.merge(and_c) }
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
