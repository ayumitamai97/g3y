# frozen_string_literal: true

module Queries
  class PostsQuery < Types::BaseQuery
    type [Types::PostType], null: false

    argument :contentOr, String, required: false, as: :content_or
    argument :contentAnd, String, required: false, as: :content_and
    argument :userId, ID, required: false, as: :user_id
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
      content_or: nil, content_and: nil, user_id: nil, username: nil,
      created_at_after: nil, created_at_before: nil, page: 0, page_per: 20
    )
      user = User.find_by(id: user_id) || User.find_by(name: username)

      return [] if (user_id.present? || username.present?) && user.nil?

      Elasticsearch::PostsQuery.new(
        content_or: content_or, content_and: content_and, user_id: user&.id,
        created_at_after: created_at_after, created_at_before: created_at_before,
        page: page, page_per: page_per
      ).call
    end
  end
end

