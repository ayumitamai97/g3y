# frozen_string_literal: true

require 'rails_helper'

# ref. Testing Interface-Level Behaviors
# https://graphql-ruby.org/testing/integration_tests#testing-interface-level-behaviors

RSpec.describe Types::QueryType do
  describe '#relationship' do
    let!(:user) { create(:user) }
    let(:query) do
      <<~GRAPHQL
        query($id: ID!){
          user(id: $id) {
            name
          }
        }
      GRAPHQL
    end

    it do
      result = G3ySchema.execute(query, variables: { id: user.id })
      expect(result.dig('data', 'user', 'name')).to eq user.name
    end
  end
end
