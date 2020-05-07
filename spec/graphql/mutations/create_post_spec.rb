# frozen_string_literal: true

require 'rails_helper'

# NOTE: メソッド単位のユニットテストではなく Interface-Level Behaviors
# https://graphql-ruby.org/testing/integration_tests#testing-interface-level-behaviors

RSpec.describe Mutations::CreatePost do
  let(:query) do
    <<~GRAPHQL
      mutation ($content: String!) {
        createPost(input: { content: $content }) {
          post {
            id
            content
            user {
              id
            }
          }
          errors
        }
      }
    GRAPHQL
  end

  context 'valid arguments' do
    let!(:user) { create(:user) }
    let(:ctx) { { current_user: user } }
    let(:variables) { { content: 'hello' } }

    it 'increments Post.count' do
      expect { G3ySchema.execute(query, variables: variables, context: ctx) }.to(change { Post.count }.by(1))
    end

    it 'returns successful object' do
      result = G3ySchema.execute(query, variables: variables, context: ctx)
      post_data = result.dig('data', 'createPost', 'post')
      expect(post_data.dig('content')).to eq variables[:content]
      expect(post_data.dig('user', 'id')).to eq user.id.to_s
    end

    it 'returns object without errors' do
      result = G3ySchema.execute(query, variables: variables, context: ctx)
      expect(result.dig('data', 'createPost', 'errors')).to be_blank
    end
  end

  context 'content is blank' do
    let!(:user) { create(:user) }
    let(:ctx) { { current_user: user } }
    let(:variables) { { content: '' } }

    it 'does not increment Post.count' do
      result = proc { G3ySchema.execute(query, variables: variables, context: ctx) }
      expect { result }.not_to(change { Post.count })
    end

    it 'returns object with errors' do
      result = G3ySchema.execute(query, variables: variables, context: ctx)
      expect(result.dig('data', 'createPost', 'errors')).to be_present
    end
  end
end
