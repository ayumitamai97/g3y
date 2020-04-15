module Types
  class UserType < Types::BaseObject
    field :id, Integer, null: false
    field :name, String, null: false
    field :posts, [Types::PostType], null: true
  end
end
