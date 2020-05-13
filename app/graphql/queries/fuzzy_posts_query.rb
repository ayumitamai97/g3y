# frozen_string_literal: true

module Queries
  class FuzzyPostsQuery < Types::BaseQuery
    type [Types::PostType], null: false

    argument :keywords, String, required: false
    argument :page, Integer, required: false
    argument :pagePer, Integer, required: false, as: :page_per

    def resolve(keywords:, page:, page_per:)
      query_body = {
        query: query(keywords: keywords),
      }.merge(meta(page: page, page_per: page_per))

      Post.search(query_body).results
    end

    private

    def query(keywords:)
      query_by_content = match_klass.new(content: keywords)

      name_match = match_klass.new(name: keywords).call
      query_by_user = has_parent_klass.new(
        parent_type: 'user',
        match_conditions: [name_match]
      )
      or_clause = query_by_user.append(query_by_content.call).build_or_clause

      or_clause.merge(and_condition([posts_base_query])) { |_key, or_c, and_c| or_c.merge(and_c) }
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
