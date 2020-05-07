# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from JWT::VerificationError, with: :not_authorized

  def authorize_user_with_token!
    token = request.headers['Authorization']
    JWT.decode(
      token,
      Rails.application.config.x.jwt_encryption_key,
      true,
      # TODO: Use constant
      { algorithm: 'HS256', iss: 'g3y', verify_iss: true }
    )
  end

  private

  def not_authorized
    render json: { error: 'Not authorized' }, status: :unauthorized
  end
end
