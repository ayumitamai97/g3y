# frozen_string_literal: true

module Queries
  class FuzzyPostsQuery < Types::BaseQuery
    type [Types::PostType], null: false

    argument :keyword, String, required: false
    argument :page, Integer, required: false
    argument :pagePer, Integer, required: false, as: :page_per

    def resolve(keyword:, page:, page_per:)
      keywords = keyword.split(/[[:blank:]]/)
      user = User.where(name: keywords).first

      # Elasticsearch::PostsQuery.new(
      #   content_or: keyword, user_id: user&.id,
      #   page: page, page_per: page_per
      # ).call
      content_queries = posts_by_content_query(keywords: keywords) || []
      parent_query = posts_by_user_query(user_id: user&.id)

      query_parts = posts_base_query
                    .push(*content_queries, parent_query)
                    .compact

      query = { bool: { should: query_parts, minimum_should_match: 2 } }
      query_body = {
        query: query&.deep_stringify_keys,
        sort: { created_at: 'desc' }, size: page_per, from: page_per * page,
      }
      Post.search(query_body).results
    end

    private

    # TODO: Refactor
    def posts_base_query
      [{ match: { relation_type: 'post' } }]
    end

    def posts_by_user_query(user_id: nil)
      return if user_id.blank?

      { parent_id: { type: 'post', id: user_id } }
    end

    def posts_by_content_query(keywords:)
      return if keywords.blank?

      keywords.map { |c| { match: { content: c } } if c.present? }
    end
  end
end
