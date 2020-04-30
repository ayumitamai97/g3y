# frozen_string_literal: true

module Mutations
  class AuthenticateUser < BaseMutation
    field :access, String, null: true
    field :access_expires_at, String, null: true
    field :errors, [String], null: true

    argument :email, String, required: true
    argument :password, String, required: true

    def resolve(email:, password:)
      user = User.find_by(email: email)

      if user.present? && user.authenticate(password)
        payload = { user_id: user.id }
        session = ::JWTSessions::Session.new(payload: payload)
        session.login.merge(errors: [])
      else
        {
          errors: ['user does not exist'],
        }
      end
    end
  end
end
