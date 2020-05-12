module Elasticsearch
  class PostsQuery < Elasticsearch::BaseQuery
    include ActiveModel::Model

    def initialize(**params)
      super(**params)
    end

    attr_accessor :content_or, :content_and, :user_id,
                  :created_at_after, :created_at_before

    def call
      if [content_or, content_and, user_id, created_at_after, created_at_before].all?(&:blank?)
        body = body(query: { match: { relation_type: 'post' } })
        Post.search(body).results
      end

      content_queries = posts_by_content_query(c_and: content_and, c_or: content_or) || []
      parent_query = posts_by_user_query(user_id: user_id)
      range_query = range(created_at_after: created_at_after, created_at_before: created_at_before)

      query_parts = posts_base_query
                .push(*content_queries, parent_query, range_query)
                .compact

      body = body(query: and_condition(query_parts))

      Post.search(body).results
    end

    private

    def posts_base_query
      [{ match: { relation_type: 'post' } }]
    end

    def posts_by_user_query(user_id: nil)
      return if user_id.blank?

      parent_id(child_type: 'post', parent_id: user_id)
    end

    def posts_by_content_query(c_and:, c_or:)
      return if [c_and, c_or].all?(&:blank?)

      [c_and&.split(/[[:blank:]]/), c_or].flatten.map { |c| match(content: c) if c.present? }
    end
  end
end
