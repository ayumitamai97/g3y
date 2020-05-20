# frozen_string_literal: true

module Mutations
  class UpdateUser < BaseMutation
    field :user, Types::UserType, null: false
    field :errors, [String], null: false

    argument :userId, ID, required: false, as: :user_id
    argument :avatarKey, String, required: true, as: :avatar_key

    def resolve(user_id: nil, avatar_key:)
      user = User.find_by(id: user_id) || current_user

      if user.update(avatar_key: avatar_key)
        {
          user: user,
          errors: [],
        }
      else
        {
          user: nil,
          errors: user.errors.full_messages,
        }
      end
    end
  end
end
