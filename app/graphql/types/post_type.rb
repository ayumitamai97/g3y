# frozen_string_literal: true

module Types
  class PostType < Types::BaseObject
    field :id, ID, null: false
    field :user, UserType, null: false
    field :content, String, null: false

    def user
      ::GraphQL::RecordLoader.for(User).load(object.user_id)
    end
  end
end
