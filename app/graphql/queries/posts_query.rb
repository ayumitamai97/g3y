# frozen_string_literal: true

module Queries
  class PostsQuery < Types::BaseQuery
    type [Types::PostType], null: false

    argument :contentOr, String, required: false, as: :content_or
    argument :contentAnd, String, required: false, as: :content_and
    argument :username, String, required: false
    argument :createdAtAfter, String,
             required: false, as: :created_at_after,
             prepare: ->(date, _ctx) { format_date(date: date) }
    argument :createdAtBefore, String,
             required: false, as: :created_at_before,
             prepare: ->(date, _ctx) { format_date(date: date) }
    argument :page, Integer, required: true
    argument :pagePer, Integer, required: true, as: :page_per

    def resolve( # rubocop:disable Metrics/ParameterLists
      content_or: nil, content_and: nil, username: nil,
      created_at_after: nil, created_at_before: nil, page: 0, page_per: 20
    )
      query_body = {
        query: query(
          content_or: content_or, content_and: content_and, username: username,
          created_at_after: created_at_after, created_at_before: created_at_before
        ),
      }.merge(meta(page: page, page_per: page_per))

      Post.search(query_body).results
    end

    private

    def query( # rubocop:disable Metrics/AbcSize
      content_or: nil, content_and: nil, username: nil,
      created_at_after: nil, created_at_before: nil
    )
      return posts_base_query if [content_or, content_and, username, created_at_after, created_at_before].all?(&:blank?)

      queries_by_content =
        [content_and&.split(/[[:blank:]]/), content_or]
        .flatten.map do |c|
          match_klass.new(content: c).call if c.present?
        end

      query_by_user = has_parent_klass.new(
        parent_type: 'user',
        match_conditions: [match_klass.new(name: username).call]
      ).call

      query_by_range =
        range_klass.new(field: 'created_at', gte: created_at_after, lte: created_at_before).call

      conditions = [posts_base_query].push(*queries_by_content, query_by_user, query_by_range).compact
      and_condition(conditions)
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
