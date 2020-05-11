# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :user, UserType, null: false do
      argument :id, ID, required: false
      argument :name, String, required: false
    end

    field :post, PostType, null: false do
      argument :id, ID, required: true
    end

    field :posts, [PostType], null: false do
      description 'Incremental searchに使われる想定'
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
    end

    def user(id: nil, name: nil)
      User.find(id)
    rescue ActiveRecord::RecordNotFound
      User.find_by!(name: name)
    end

    def post(id:)
      Post.find(id)
    end

    def posts( # rubocop:disable Metrics/ParameterLists
      content_or: nil, content_and: nil, user_id: nil, username: nil,
      created_at_after: nil, created_at_before: nil, page: 0, page_per: 20
    )
      user = User.find_by(id: user_id) || User.find_by(name: username)
      return [] if (user_id.present? || username.present?) && user.nil?

      req = {
        query: posts_query(
          content_or: content_or, content_and: content_and, user_id: user&.id,
          created_at_after: created_at_after, created_at_before: created_at_before
        ).deep_stringify_keys,
        sort: { created_at: 'desc' }, size: page_per, from: page_per * page,
      }

      Post.search(req).results
    end

    private

    # Example:
    # {
    #   bool: {
    #     must: {
    #       [
    #         { match: { content: 'and_1' } },
    #         { match: { content: 'and_2' } },
    #         { match: { content: 'or_1 or_2' } },
    #         { parent_id: { type: child_type, id: parent_id } }
    #       ]
    #     }
    #   }
    # }

    def posts_query(content_or: nil, content_and: nil, user_id: nil, created_at_after: nil, created_at_before: nil)
      # TODO: kuromoji

      if [content_or, content_and, user_id, created_at_after, created_at_before].all?(&:blank?)
        return { match: { relation_type: 'post' } }
      end

      content_queries = posts_by_content_query(c_and: content_and, c_or: content_or) || []
      parent_query = posts_by_user_query(user_id: user_id)
      range_query = range(created_at_after: created_at_after, created_at_before: created_at_before)

      queries = posts_base_query
                .push(*content_queries, parent_query, range_query)
                .compact

      and_condition(queries)
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

      [c_and&.split(/[[:blank:]]/), c_or]
        .map { |c| match(content: c) if c.present? }
    end

    def parent_id(child_type:, parent_id:)
      { parent_id: { type: child_type, id: parent_id } }
    end

    def match(hash)
      { match: hash }
    end

    def range(created_at_after: nil, created_at_before: nil)
      return if [created_at_after, created_at_before].all?(&:blank?)

      {
        range: {
          created_at: {
            gte: created_at_after.presence,
            lte: created_at_before.presence,
          },
        },
      }
    end

    def and_condition(queries)
      { bool: { must: queries } }
    end
  end
end
