# frozen_string_literal: true

require 'rails_helper'

# ref. Testing Interface-Level Behaviors
# https://graphql-ruby.org/testing/integration_tests#testing-interface-level-behaviors

RSpec.describe Types::QueryType do
  describe '#followings' do
    let!(:follower_user) { create(:user) }
    let!(:followed_user) { create(:user) }
    let(:query) do
      <<~GRAPHQL
        query($followerId: ID!) {
          followings(followerId: $followerId, page: 0, pagePer: 100) {
            followingId
            followingName
          }
        }
      GRAPHQL
    end

    before do
      sleep 2
      follower_user.follow(user: followed_user)
      sleep 2
    end

    after do
      Elasticsearch::DeleteIndicesService.new.execute
      Elasticsearch::CreateIndicesService.new.execute

      sleep 3
    end

    it do
      result = G3ySchema.execute(query, variables: { followerId: follower_user.id })
      expect(result.dig('data', 'followings').count).to eq 1
      expect(result.dig('data', 'followings').first['followingId']).to eq followed_user.id.to_s
    end
  end
end
