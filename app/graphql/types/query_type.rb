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
    end

    def user(id: nil, name: nil)
      User.find(id)
    rescue StandardError
      User.find_by!(name: name)
    end

    def post(id:)
      Post.find(id)
    end

    def posts(content: nil, user_id: nil)
      # TODO: kuromoji
      # TODO: pagination https://github.com/elastic/elasticsearch-rails/blob/19851a0273d74a2a80a99dd0309f0052046646b5/elasticsearch-model/README.md#pagination

      query = if content.blank? && user_id.blank?
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

      Post.search(query: query.deep_stringify_keys, sort: { created_at: 'desc' }).results
    end
  end
end
