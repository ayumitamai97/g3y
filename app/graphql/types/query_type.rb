module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :user, UserType, null: false do
      description "user user user"
      argument :id, ID, required: false
      argument :name, String, required: false
    end

    field :post, PostType, null: false do
      description "post post post"
      argument :id, ID, required: true
    end

    def post(id:)
      Post.find(id)
    end

    def user(id: nil, name: nil)
      User.find(id) || User.find_by!(name: name)
    end
  end
end
