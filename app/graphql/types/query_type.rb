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
      argument :content, String, required: false
      argument :userId, ID, required: false, as: :user_id
      argument :page, Integer, required: false
      argument :pagePer, Integer, required: false, as: :page_per
    end

    def user(id: nil, name: nil)
      User.find(id)
    rescue StandardError
      User.find_by!(name: name)
    end

    def post(id:)
      Post.find(id)
    end

    def posts(content: nil, user_id: nil, page: 0, page_per: 20)
      req = {
        query: posts_query(content: content, user_id: user_id).deep_stringify_keys,
        sort: { created_at: 'desc' },
        size: page_per,
        from: page_per * page,
      }
      # TODO: resolve N+1 query
      Post.search(req).results
    end

    def posts_query(content:, user_id:)
      # TODO: kuromoji

      if content.blank? && user_id.blank?
        { match: { relation_type: 'post' } }
      elsif content.blank? && user_id.present?
        { parent_id: { type: 'post', id: user_id } }
      elsif content.present? && user_id.blank?
        { match: { content: content } }
      else
        {
          bool: {
            must: [
              { parent_id: { type: 'post', id: user_id } },
              { match: { content: content } }
            ]
          }
        }
      end
    end
  end
end
