# frozen_string_literal: true

module Mutations
  class AuthenticateUser < BaseMutation
    field :access, String, null: true
    field :access_expires_at, String, null: true
    field :errors, [String], null: true

    argument :email, String, required: true
    argument :password, String, required: true

    # TODO: refresh
    def resolve(email:, password:)
      binding.pry
      user = User.find_by(email: email)

      if user.present? && user.authenticate(password)
        {
          access: token(user: user),
          access_expires_at: expires_at,
        }
      else
        { errors: ['user does not exist'] }
      end
    end

    private

    def token(user:)
      JWT.encode(
        {
          user_id: user.id,
          user_name: user.name,
          iss: Rails.application.config.x.jwt_iss,
        },
        Rails.application.config.x.jwt_encryption_key,
        'HS256'
      )
    end

    def expires_at
      Time.zone.now + 4 * 3600
    end
  end
end
