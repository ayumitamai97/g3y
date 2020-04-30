# frozen_string_literal: true

module Types
  class PostType < Types::BaseObject
    field :id, ID, null: false
    field :user, UserType, null: false
    field :content, String, null: false
    field :created_at, String, null: false

    def user
      RecordLoader.for(User).load(object.user_id)
    end

    def created_at
      I18n.l(object.created_at.to_datetime, format: :custom)
    end
  end
end
