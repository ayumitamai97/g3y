# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Elasticsearch::PostsQuery do
  describe '#call' do
    let!(:user) { create(:user) }

    before do
      ActiveRecord::Base.transaction do
        user.posts.create!(content: 'hello')
        user.posts.create!(content: 'hello world')
      end

      sleep 3
    end

    after do
      Elasticsearch::DeleteIndicesService.new.execute
      Elasticsearch::CreateIndicesService.new.execute

      sleep 3
    end

    context 'without any parameter except for pagination' do
      it 'returns all posts' do
        obj = Elasticsearch::PostsQuery.new(page: 0, page_per: 20).call
        expect(obj).to be_present
        expect { obj }.not_to raise_error
        expect(obj.count).to eq Post.take(20).count
      end
    end

    context 'with content' do
      it 'returns one matching post' do
        obj = Elasticsearch::PostsQuery.new(content_and: 'hello world', page: 0, page_per: 20).call
        expect(obj).to be_present
        expect { obj }.not_to raise_error
        expect(obj.count).to eq 1
      end
    end
  end
end
