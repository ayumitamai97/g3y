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

  describe '#posts (with single "content" condition)' do
    let!(:first_user) { create(:user) }

    before do
      # First user
      ActiveRecord::Base.transaction do
        first_user.posts.create!(content: 'happy birthday')
        first_user.posts.create!(content: 'hello')
        5.times { |n| create(:post, user: first_user, content: ['good morning', 'good night'][n % 2]) }
        sleep 3

        # Second user
        second_user = create(:user)
        second_user.posts.create!(content: 'hello')
        5.times { |n| create(:post, user: second_user, content: ['good morning', 'good night'][n % 2]) }
      end

      sleep 3
    end

    after do
      Elasticsearch::DeleteIndicesService.new.execute
      Elasticsearch::CreateIndicesService.new.execute

      sleep 3
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

    context 'search by contentOr' do
      let(:query) do
        <<~GRAPHQL
          query($contentOr: String!) {
            posts(contentOr: $contentOr, pagePer: 100) {
              content
              user {
                id
              }
            }
          }
        GRAPHQL
      end

      it 'returns all the posts containing query string' do
        query_string = 'hello'
        result = G3ySchema.execute(query, { variables: { contentOr: query_string } })
        result_posts = result.dig('data', 'posts')

        expect(result_posts.count).to eq Post.where(content: query_string).count
        expect(result_posts.first['content']).to eq query_string
      end
    end

    context 'search by contentAnd' do
      let(:query) do
        <<~GRAPHQL
          query($contentAnd: String!) {
            posts(contentAnd: $contentAnd, pagePer: 100) {
              content
              user {
                id
              }
            }
          }
        GRAPHQL
      end

      it 'returns all the posts containing query string' do
        query_string = 'good morning'
        result = G3ySchema.execute(query, { variables: { contentAnd: query_string } })
        result_posts = result.dig('data', 'posts')

        expect(result_posts.count).to eq Post.where(content: query_string).count
        expect(result_posts.first['content']).to eq query_string
      end
    end

    context 'search by both user_id and contentOr' do
      let(:query) do
        <<~GRAPHQL
          query($contentOr: String!, $user_id: ID!) {
            posts(contentOr: $contentOr, userId: $user_id, pagePer: 100) {
              content
              user {
                id
              }
            }
          }
        GRAPHQL
      end

      it 'returns the posts by first_user containing query string' do
        query_string = 'hello'
        result = G3ySchema.execute(query, {
                                     variables: {
                                       contentOr: query_string,
                                       user_id: first_user.id,
                                     },
                                   })
        result_posts = result.dig('data', 'posts')

        expect(result_posts.count).to eq Post.where(content: query_string, user: first_user).count
        expect(result_posts.first['content']).to eq query_string
      end
    end
  end

  describe '#posts (with multiple "content" condition)' do
    let!(:user) { create(:user) }

    before do
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
          query($contentOr: String!, $contentAnd: String!) {
            posts(contentOr: $contentOr, contentAnd: $contentAnd, pagePer: 100) {
              content
              user {
                id
              }
            }
          }
        GRAPHQL
      end

      it 'returns two matching posts' do
        query_string_and = 'apple banana'
        query_string_or = 'cherry dragonfruit'
        result = G3ySchema.execute(query, { variables: { contentOr: query_string_or, contentAnd: query_string_and } })
        result_posts = result.dig('data', 'posts')

        expect(result_posts.count).to eq 2
        expect(result_posts.first['content']).to include 'apple'
        expect(result_posts.first['content']).to include 'banana'
        expect(result_posts.first['content'].include?('cherry') || result_posts.first['content'].include?('dragonfruit')).to eq true
      end

      it 'returns three matching posts' do
        query_string_and = 'apple'
        query_string_or = 'cherry dragonfruit'
        result = G3ySchema.execute(query, { variables: { contentOr: query_string_or, contentAnd: query_string_and } })
        result_posts = result.dig('data', 'posts')

        expect(result_posts.count).to eq 3
        expect(result_posts.first['content']).to include 'apple'
        expect(result_posts.first['content'].include?('cherry') || result_posts.first['content'].include?('dragonfruit')).to eq true
      end
    end
  end
end
