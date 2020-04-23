# frozen_string_literal: true

require 'rails_helper'

# ref. Testing Interface-Level Behaviors
# https://graphql-ruby.org/testing/integration_tests#testing-interface-level-behaviors

RSpec.describe Types::QueryType do
  describe '#user' do
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

  describe '#post' do
    let!(:post) { create(:post) }
    let(:query) do
      <<~GRAPHQL
        query($id: ID!) {
          post(id: $id) {
            content
          }
        }
      GRAPHQL
    end

    it do
      result = G3ySchema.execute(query, variables: { id: post.id })
      expect(result.dig('data', 'post', 'content')).to eq post.content
    end
  end

  describe '#posts' do
    let(:query_content_string) { 'hello' }
    let!(:first_user) { create(:user) }

    around(:each) do |e|
      Elasticsearch::DeleteIndicesService.new.execute
      Elasticsearch::CreateIndicesService.new.execute
      e.run
      Elasticsearch::DeleteIndicesService.new.execute
    end

    before do
      # First user
      first_user.posts.create!(content: 'happy birthday')
      first_user.posts.create!(content: 'hello')
      create_list(:post, 5, user: first_user, content: ['good morning', 'good evening', 'good night'].sample)

      # Second user
      second_user = create(:user)
      second_user.posts.create!(content: 'hello')
      create_list(:post, 5, user: second_user, content: ['good morning', 'good evening', 'good night'].sample)
      sleep 1 # Wait for indexing?
    end

    context 'search latest 100 posts' do
      let(:query) do
        <<~GRAPHQL
          {
            posts(pagePer: 100) {
              id
              content
            }
          }
        GRAPHQL
      end

      it 'returns all the posts' do
        result = G3ySchema.execute(query)
        expect(result.dig('data', 'posts').count).to eq Post.count
      end
    end

    context 'search by user_id' do
      let(:query) do
        <<~GRAPHQL
          query($user_id: ID!) {
            posts(userId: $user_id, pagePer: 100) {
              content
              user {
                id
                name
              }
            }
          }
        GRAPHQL
      end

      it 'returns all the posts from first_user' do
        result = G3ySchema.execute(query, { variables: { user_id: first_user.id } })
        result_posts = result.dig('data', 'posts')

        expect(result_posts.count).to eq first_user.posts.count
        expect(result_posts.map { |p| p.dig('user') }.uniq.count).to eq 1
        expect(result_posts.map { |p| p.dig('user') }.uniq.first['id']).to eq first_user.id.to_s
      end
    end

    context 'search by content' do
      let(:query) do
        <<~GRAPHQL
          query($content: String!) {
            posts(content: $content, pagePer: 100) {
              content
              user {
                id
                name
              }
            }
          }
        GRAPHQL
      end

      it 'returns all the posts containing query string' do
        result = G3ySchema.execute(query, { variables: { content: query_content_string } })
        result_posts = result.dig('data', 'posts')

        expect(result_posts.count).to eq Post.where(content: query_content_string).count
        expect(result_posts.first['content']).to eq query_content_string
      end
    end

    context 'search by both user_id and content' do
      let(:query) do
        <<~GRAPHQL
          query($content: String!, $user_id: ID!) {
            posts(content: $content, userId: $user_id, pagePer: 100) {
              content
              user {
                id
                name
              }
            }
          }
        GRAPHQL
      end

      it 'returns the posts by first_user containing query string' do
        result = G3ySchema.execute(query, {
                                     variables: {
                                       content: query_content_string,
                                       user_id: first_user.id,
                                     },
                                   })
        result_posts = result.dig('data', 'posts')

        expect(result_posts.count).to eq Post.where(content: query_content_string, user: first_user).count
        expect(result_posts.first['content']).to eq query_content_string
      end
    end
  end
end
