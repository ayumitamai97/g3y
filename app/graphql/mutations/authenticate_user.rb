# frozen_string_literal: true

module Mutations
  class AuthenticateUser < BaseMutation
    # TODO: ほんとにこれでいいのか？？
    field :access, String, null: true
    field :access_expires_at, String, null: true
    field :errors, [String], null: true

    argument :email, String, required: true
    argument :password, String, required: true

    def resolve(email:, password:)
      user = User.find_by!(email: email)

      if user.authenticate(password)
        payload = { user_id: user.id }
        session = ::JWTSessions::Session.new(payload: payload)
        session.login.merge(errors: [])
      else
        {
          errors: ['invalid'],
        }
      end
    end
  end
end
