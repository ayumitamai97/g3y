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
      user = User.find_by(email: email)

      if user.present? && user.authenticate(password)
        session = ::JWTSessions::Session.new(payload: payload(user: user))
        session.login.merge(errors: [])
      else
        {
          errors: ['user does not exist'],
        }
      end
    end

    def payload(user:)
      {
        user_id: user.id,
        user_name: user.name,
      }
    end
  end
end
