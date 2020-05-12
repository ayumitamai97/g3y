# frozen_string_literal: true

module Queries
  class FuzzyPostsQuery < Types::BaseQuery
    type [Types::PostType], null: false

    argument :keyword, String, required: false
    argument :page, Integer, required: false
    argument :pagePer, Integer, required: false, as: :page_per

    def resolve(keyword:, page:, page_per:)
      # TODO: where or elasticseach
      # TODO: OR search
      user = User.find_by(name: keyword)

      Elasticsearch::PostsQuery.new(
        content_or: keyword, user_id: user&.id,
        page: page, page_per: page_per
      ).call
    end
  end
end
