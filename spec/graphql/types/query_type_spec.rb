# frozen_string_literal: true

require 'rails_helper'

# ref. Testing Interface-Level Behaviors
# https://graphql-ruby.org/testing/integration_tests#testing-interface-level-behaviors

RSpec.describe Types::QueryType do
  describe '#relationship' do
    let!(:followed) { create(:user) }
    let!(:follower) { create(:user) }
    let(:query) do
      <<~GRAPHQL
        query($followingId: ID!, $followerId: ID!){
          relationship (followingId: $followingId, followerId: $followerId) {
            id
            followingId
          }
        }
      GRAPHQL
    end
    before { follower.follow(user: followed) }

    it do
      result = G3ySchema.execute(query, variables: { followingId: followed.id, followerId: follower.id })
      expect(result.dig('data', 'relationship', 'followingId')).to eq followed.id.to_s
    end
  end
end
