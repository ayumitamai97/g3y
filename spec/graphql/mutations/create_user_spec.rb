require 'rails_helper'

# NOTE: メソッド単位のユニットテストではなく Interface-Level Behaviors
# https://graphql-ruby.org/testing/integration_tests#testing-interface-level-behaviors

RSpec.describe Mutations::CreateUser do
  let(:query) do
    <<~GRAPHQL
      mutation ($name: String!, $email: String!, $password: String!) {
        createUser(input: { name: $name, email: $email, password: $password }) {
          user {
            id
            name
            email
          }
          errors
        }
      }
    GRAPHQL
  end

  context 'valid arguments' do
    let(:variables) do
      {
        name: 'testuser',
        email: 'testuser@example.com',
        password: 'password',
      }
    end

    it 'increments User.count' do
      expect { G3ySchema.execute(query, variables: variables) }.to change { User.count }.by 1
    end

    it 'returns successful object' do
      result = G3ySchema.execute(query, variables: variables)
      user_data = result.dig('data', 'createUser', 'user')
      expect(user_data.dig('name')).to eq variables[:name]
      expect(user_data.dig('email')).to eq variables[:email]
    end

    it 'returns object without errors' do
      result = G3ySchema.execute(query, variables: variables)
      expect(result.dig('data', 'createUser', 'errors')).to be_blank
    end
  end

  context 'name is blank' do
    let(:variables) do
      {
        name: '',
        email: 'testuser@example.com',
        password: 'password',
      }
    end

    it 'does not increment User.count' do
      expect { G3ySchema.execute(query, variables: variables) }.not_to change { User.count }
    end

    it 'returns object with errors' do
      result = G3ySchema.execute(query, variables: variables)
      expect(result.dig('data', 'createUser', 'errors')).to be_present
    end
  end

  context 'email is blank' do
    let(:variables) do
      {
        name: 'testuser',
        email: '',
        password: 'password',
      }
    end

    it 'does not increment User.count' do
      expect { G3ySchema.execute(query, variables: variables) }.not_to change { User.count }
    end

    it 'returns object with errors' do
      result = G3ySchema.execute(query, variables: variables)
      expect(result.dig('data', 'createUser', 'errors')).to be_present
    end
  end

  context 'password is blank' do
    let(:variables) do
      {
        name: 'testuser',
        email: 'testuser@example.com',
        password: '',
      }
    end

    it 'does not increment User.count' do
      expect { G3ySchema.execute(query, variables: variables) }.not_to change { User.count }
    end

    it 'returns object with errors' do
      result = G3ySchema.execute(query, variables: variables)
      expect(result.dig('data', 'createUser', 'errors')).to be_present
    end
  end

  context 'name is taken' do
    before { create(:user, name: 'testuser') }

    let(:variables) do
      {
        name: 'testuser',
        email: 'testuser@example.com',
        password: 'password',
      }
    end

    it 'does not increment User.count' do
      expect { G3ySchema.execute(query, variables: variables) }.not_to change { User.count }
    end

    it 'returns object with errors' do
      result = G3ySchema.execute(query, variables: variables)
      expect(result.dig('data', 'createUser', 'errors')).to be_present
    end
  end
end
