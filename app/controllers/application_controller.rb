# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from JWT::VerificationError, with: :not_authorized

  private

  def authorize_user_with_token!
    decoded_token
  end

  def current_user
    User.find(decoded_token.first['user_id'])
  end

  def decoded_token
    JWT.decode(
      token,
      Rails.application.config.x.jwt_encryption_key,
      true,
      { algorithm: 'HS256', iss: Rails.application.config.x.jwt_iss, verify_iss: true }
    )
  end

  def token
    request.headers['Authorization']
  end

  def not_authorized
    render json: { error: 'Not authorized' }, status: :unauthorized
  end
end
