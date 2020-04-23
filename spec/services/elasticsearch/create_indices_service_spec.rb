# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Elasticsearch::CreateIndicesService do
  before { Elasticsearch::DeleteIndicesService.new.execute }
  let(:client) { Elasticsearch::Model.client }

  it do
    existing_indices = client.indices.stats['indices'].keys
    expect(existing_indices).not_to include UserAndPostSearchable::INDEX_NAME
    described_class.new.execute
    new_existing_indices = client.indices.stats['indices'].keys
    expect(new_existing_indices).to include UserAndPostSearchable::INDEX_NAME
  end
end
