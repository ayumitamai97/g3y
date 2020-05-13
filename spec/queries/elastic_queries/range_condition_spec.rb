# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ElasticQueries::RangeCondition do
  describe '#append' do
    let(:field) { 'created_at' }
    let(:gte) { '2020-05-10' }
    let(:lte) { '2020-05-13' }
    let(:another_query) { { match: { content: 'test' } } }

    it 'returns self when giving valid arguments' do
      object = described_class.new(field: field, gte: gte, lte: lte)
      append = object.append(another_query)
      expect(append).to eq object
    end

    it 'changes conditions when giving valid arguments' do
      object = described_class.new(field: field, gte: gte, lte: lte)
      expect { object.append(another_query) }.to(change { object.conditions })
    end

    it 'returns nil when giving invalid arguments' do
      object = described_class.new(field: nil, gte: nil, lte: nil)
      append = object.append(another_query)
      expect(append).to eq object
      expect { object.append(another_query) }.not_to(change { object.conditions })
    end

    it 'returns nil when giving invalid arguments' do
      object = described_class.new(field: field, gte: gte, lte: lte)
      append = object.append('')
      expect(append).to eq object
      expect { object.append('') }.not_to(change { object.conditions })
    end
  end

  describe '#call' do
    let(:field) { 'created_at' }
    let(:gte) { '2020-05-10' }
    let(:lte) { '2020-05-13' }
    let(:valid_query) do
      {
        range: {
          field => { gte: gte, lte: lte },
        },
      }
    end

    it 'returns an elasticsearch query when giving valid arguments' do
      query = described_class.new(field: field, gte: gte, lte: lte).call
      expect(query).to eq valid_query
    end

    it 'returns nil when giving invalid arguments' do
      query = described_class.new(field: nil, gte: nil, lte: nil).call
      expect(query).to eq nil
    end
  end

  describe '#build_or_clause' do
    let(:field) { 'created_at' }
    let(:gte) { '2020-05-10' }
    let(:lte) { '2020-05-13' }
    let(:another_query) { { match: { content: 'test' } } }
    let(:valid_bool_query) do
      {
        bool: {
          should: [
            { range: { field => { gte: gte, lte: lte } } },
            { match: { content: 'test' } },
          ],
          minimum_should_match: 1,
        },
      }
    end

    it 'returns self when giving valid arguments' do
      object = described_class.new(field: field, gte: gte, lte: lte)
      append = object.append(another_query)
      expect(append.build_or_clause).to eq valid_bool_query
    end

    it 'returns nil when giving invalid arguments' do
      object = described_class.new(field: nil, gte: nil, lte: nil)
      append = object.append(another_query)
      expect(append.build_or_clause).not_to eq valid_bool_query
    end

    it 'returns nil when giving invalid arguments' do
      object = described_class.new(field: field, gte: gte, lte: lte)
      append = object.append('')
      expect(append.build_or_clause).not_to eq valid_bool_query
    end
  end
end
