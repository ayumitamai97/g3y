module Mutations
  class CreatePost < BaseMutation
    field :post, Types::PostType, null: false
    field :errors, [String], null: false

    argument :content, String, required: true

    def resolve(content:)
      post = current_user.posts.create(content: content)

      {
        post: post.persisted? ? post : nil,
        errors: post.errors.full_messages,
      }
    end

    def current_user
      context[:current_user]
    end
  end
end
