# frozen_string_literal: true

namespace :es do
  task create_indices: :environment do
    Elasticsearch::CreateIndicesService.new.execute
  end

  task delete_indices: :environment do
    Elasticsearch::DeleteIndicesService.new.execute
  end
end
