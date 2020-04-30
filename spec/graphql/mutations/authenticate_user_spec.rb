# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::AuthenticateUser do
  let(:query) do
    <<~GRAPHQL
      mutation ($email: String!, $password: String!) {
        authenticateUser(input: { email: $email, password: $password }) {
          access
          accessExpiresAt
          errors
        }
      }
    GRAPHQL
  end
  let!(:email) { 'testuser@example.com' }
  let!(:password) { 'password' }
  let!(:user) { create(:user, email: email, password: password) }

  context 'valid arguments' do
    let(:variables) do
      {
        email: email,
        password: password,
      }
    end

    it 'access and accessExpiresAt are present' do
      result = G3ySchema.execute(query, variables: variables)
      data = result.dig('data', 'authenticateUser')
      expect(data['access']).to be_present
      expect(data['accessExpiresAt']).to be_present
    end
  end

  context 'not existing email' do
    let(:variables) do
      {
        email: 'user_not_existing@example.com',
        password: password,
      }
    end

    it 'access and accessExpiresAt are null' do
      result = G3ySchema.execute(query, variables: variables)
      data = result.dig('data', 'authenticateUser')
      expect(data['access']).to be_nil
      expect(data['errors']).to be_present
    end
  end

  context 'invalid password' do
    let(:variables) do
      {
        email: email,
        password: 'invalid_password',
      }
    end

    it 'access and accessExpiresAt are null' do
      result = G3ySchema.execute(query, variables: variables)
      data = result.dig('data', 'authenticateUser')
      expect(data['access']).to be_nil
      expect(data['accessExpiresAt']).to be_nil
    end
  end
end
