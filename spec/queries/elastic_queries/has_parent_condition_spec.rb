# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ElasticQueries::HasParentCondition do
  describe '#append' do
    let(:name) { 'testuser' }
    let(:another_query) { { match: { content: 'test' } } }

    it 'returns self when giving valid arguments' do
      object = described_class.new(parent_type: 'user', match_conditions: [{ name: name }])
      append = object.append(another_query)
      expect(append).to eq object
    end

    it 'changes conditions when giving valid arguments' do
      object = described_class.new(parent_type: 'user', match_conditions: [{ name: name }])
      expect { object.append(another_query) }.to(change { object.conditions })
    end

    it 'returns nil when giving invalid arguments' do
      object = described_class.new(parent_type: 'user', match_conditions: [nil])
      append = object.append(another_query)
      expect(append).to eq object
      expect { object.append(another_query) }.not_to(change { object.conditions })
    end

    it 'returns nil when giving invalid arguments' do
      object = described_class.new(parent_type: 'user', match_conditions: [{ name: name }])
      append = object.append('')
      expect(append).to eq object
      expect { object.append('') }.not_to(change { object.conditions })
    end
  end

  describe '#call' do
    let(:name) { 'testuser' }
    let(:valid_query) do
      {
        has_parent: {
          parent_type: 'user',
          query: { bool: { should: [{ name: name }] } },
        },
      }
    end

    it 'returns an elasticsearch query when giving valid arguments' do
      query = described_class.new(parent_type: 'user', match_conditions: [{ name: name }]).call
      expect(query).to eq valid_query
    end

    it 'returns nil when giving invalid arguments' do
      query = described_class.new(parent_type: 'user', match_conditions: [nil]).call
      expect(query).to eq nil
    end
  end

  describe '#build_or_clause' do
    let(:name) { 'testuser' }
    let(:another_query) { { match: { content: 'test' } } }
    let(:valid_bool_query) do
      {
        bool: {
          should: [
            {
              has_parent: {
                parent_type: 'user',
                query: {
                  bool: { should: [{ name: 'testuser' }] },
                },
              },
            },
            { match: { content: 'test' } },
          ],
          minimum_should_match: 1,
        },
      }
    end

    it 'returns self when giving valid arguments' do
      object = described_class.new(parent_type: 'user', match_conditions: [{ name: name }])
      append = object.append(another_query)
      expect(append.build_or_clause).to eq valid_bool_query
    end

    it 'returns nil when giving invalid arguments' do
      object = described_class.new(parent_type: 'user', match_conditions: [nil])
      append = object.append(another_query)
      expect(append.build_or_clause).not_to eq valid_bool_query
    end

    it 'returns nil when giving invalid arguments' do
      object = described_class.new(parent_type: 'user', match_conditions: [{ name: name }])
      append = object.append('')
      expect(append.build_or_clause).not_to eq valid_bool_query
    end
  end
end
