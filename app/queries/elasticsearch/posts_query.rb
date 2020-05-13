# frozen_string_literal: true

module Elasticsearch
  class PostsQuery < Elasticsearch::BaseQuery
    def initialize(**params)
      super(**params)
    end

    attr_accessor :content_or, :content_and, :user_id,
                  :created_at_after, :created_at_before

    def call
      validate!

      query_body = body(query: query)
      Post.search(query_body).results
    end

    private

    def query
      return { match: { relation_type: 'post' } } if params_blank?

      content_queries = posts_by_content_query(c_and: content_and, c_or: content_or) || []
      parent_query = posts_by_user_query(user_id: user_id)
      range_query = range(created_at_after: created_at_after, created_at_before: created_at_before)

      query_parts = posts_base_query
                    .push(*content_queries, parent_query, range_query)
                    .compact

      and_condition(query_parts)
    end

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

    def params_blank?
      [content_or, content_and, user_id, created_at_after, created_at_before].all?(&:blank?)
    end
  end
end
