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
      argument :userId, ID, required: false, as: :user_id, prepare: lambda { |id, _ctx|
        if id.present?
          User.exists?(id: id) ? id : raise(ActiveRecord::RecordNotFound)
        end
      }
      argument :username, String, required: false, prepare: lambda { |name, _ctx|
        if name.present?
          User.exists?(name: name) ? name : raise(ActiveRecord::RecordNotFound)
        end
      }
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

    def posts(content_or: nil, content_and: nil, user_id: nil, username: nil, page: 0, page_per: 20) # rubocop:disable Metrics/ParameterLists
      user = User.find_by(id: user_id) || User.find_by(name: username)

      req = {
        query: posts_query(content_or: content_or, content_and: content_and, user_id: user&.id).deep_stringify_keys,
        sort: { created_at: 'desc' },
        size: page_per,
        from: page_per * page,
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

    def posts_query(content_or: nil, content_and: nil, user_id: nil)
      # TODO: kuromoji

      return { match: { relation_type: 'post' } } if content_or.blank? && content_and.blank? && user_id.blank?

      content_queries = content_and.split(/[[:blank:]]/).push(content_or)
                                   .map { |c| match(content: c) if c.present? }

      parent_query = user_id.present? ? post_by_user(user_id: user_id) : nil
      queries = content_queries.push(parent_query).compact

      and_condition(queries)
    end

    def post_by_user(user_id:)
      parent_id(child_type: 'post', parent_id: user_id)
    end

    def parent_id(child_type:, parent_id:)
      { parent_id: { type: child_type, id: parent_id } }
    end

    def match(hash)
      { match: hash }
    end

    def and_condition(queries)
      { bool: { must: queries } }
    end
  end
end
