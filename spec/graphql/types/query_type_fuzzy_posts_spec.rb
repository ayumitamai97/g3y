# frozen_string_literal: true

require 'rails_helper'

# ref. Testing Interface-Level Behaviors
# https://graphql-ruby.org/testing/integration_tests#testing-interface-level-behaviors

RSpec.describe Types::QueryType do
  describe '#fuzzy_posts' do
    let(:name) { 'testuser' }
    let!(:user) { create(:user, name: name) }

    before do
      sleep 3
      ActiveRecord::Base.transaction do
        user.posts.create!(content: 'apple banana cherry dragonfruit')
        user.posts.create!(content: 'apple banana dragonfruit')
        user.posts.create!(content: 'apple cherry')
      end

      sleep 3
    end

    after do
      Elasticsearch::DeleteIndicesService.new.execute
      Elasticsearch::CreateIndicesService.new.execute

      sleep 3
    end

    context 'search by contentOr and contentAnd' do
      let(:query) do
        <<~GRAPHQL
          query($keywords: String!) {
            fuzzyPosts(keywords: $keywords, page: 0, pagePer: 100) {
              content
              user {
                id
              }
            }
          }
        GRAPHQL
      end

      it 'returns two matching posts' do
        result = G3ySchema.execute(query, { variables: { keywords: "#{name} cherry" } })
        result_posts = result.dig('data', 'fuzzyPosts')

        expect(result_posts.count).to eq 3
        expect(result_posts.first['content']).to include 'cherry'
      end
    end
  end
end
