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
    argument :page, Integer, required: false
    argument :pagePer, Integer, required: false, as: :page_per

    def resolve( # rubocop:disable Metrics/ParameterLists
      content_or: nil, content_and: nil, username: nil,
      created_at_after: nil, created_at_before: nil, page: 0, page_per: 20
    )
      queries_by_content = [content_and&.split(/[[:blank:]]/), content_or].flatten
                                                                          .map do |c|
        match_klass.new(content: c).call if c.present?
      end

      name_match = match_klass.new(name: username).call
      query_by_user = has_parent_klass.new(
        parent_type: 'user',
        match_conditions: [name_match]
      ).call

      query_by_range = range_klass.new(
        field: 'created_at',
        gte: created_at_after,
        lte: created_at_before
      ).call

      query_parts = [posts_base_query]
                    .push(*queries_by_content, query_by_user, query_by_range)
                    .compact

      query_body = {
        query: and_condition(query_parts),
      }.merge(meta(page: page, page_per: page_per))

      Post.search(query_body).results
    end

    private

    def and_condition(queries)
      { bool: { must: queries } }
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
