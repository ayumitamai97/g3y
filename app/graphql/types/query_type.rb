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

    def posts(content: nil, user_id: nil) # rubocop:disable Lint/UnusedMethodArgument
      # TODO: kuromoji
      # TODO: pagination https://github.com/elastic/elasticsearch-rails/blob/19851a0273d74a2a80a99dd0309f0052046646b5/elasticsearch-model/README.md#pagination

      # TODO: search by user_id
      query = if content.blank?
                { match_all: {} }
              else
                { match: { content: content } }
              end

      Post.search(query: query).records.to_a
    end
  end
end
