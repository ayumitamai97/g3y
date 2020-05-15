# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ElasticQueries::MatchCondition do
  describe '#append' do
    let(:content) { 'test' }
    let(:another_query) { { match: { content: 'test2' } } }

    it 'returns self when giving valid arguments' do
      object = described_class.new(content: content)
      append = object.append(another_query)
      expect(append).to eq object
    end

    it 'changes conditions when giving valid arguments' do
      object = described_class.new(content: content)
      expect { object.append(another_query) }.to(change { object.conditions })
    end

    it 'returns nil when giving invalid arguments' do
      object = described_class.new(content: '')
      append = object.append(another_query)
      expect(append).to eq object
      expect { object.append(another_query) }.not_to(change { object.conditions })
    end

    it 'returns nil when giving invalid arguments' do
      object = described_class.new(content: content)
      append = object.append('')
      expect(append).to eq object
      expect { object.append('') }.not_to(change { object.conditions })
    end
  end

  describe '#call' do
    let(:content) { 'test' }
    let(:valid_query) do
      { match: { content: content } }
    end

    it 'returns an elasticsearch query when giving valid arguments' do
      query = described_class.new(content: content).call
      expect(query).to eq valid_query
    end

    it 'returns nil when giving invalid arguments' do
      query = described_class.new(content: '').call
      expect(query).to eq nil
    end
  end

  describe '#build_or_clause' do
    let(:content) { 'test' }
    let(:another_query) { { match: { content: 'test2' } } }
    let(:valid_bool_query) do
      # 同じfieldのOR検索ならこうする必要はないが、便宜上
      {
        bool: {
          should: [
            { match: { content: 'test' } },
            { match: { content: 'test2' } },
          ],
        },
      }
    end

    it 'returns self when giving valid arguments' do
      object = described_class.new(content: content)
      append = object.append(another_query)
      expect(append.build_or_clause).to eq valid_bool_query
    end

    it 'returns nil when giving invalid arguments' do
      object = described_class.new(content: nil)
      append = object.append(another_query)
      expect(append.build_or_clause).not_to eq valid_bool_query
    end

    it 'returns nil when giving invalid arguments' do
      object = described_class.new(content: content)
      append = object.append('')
      expect(append.build_or_clause).not_to eq valid_bool_query
    end
  end
end
