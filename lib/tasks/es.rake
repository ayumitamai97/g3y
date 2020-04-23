# frozen_string_literal: true

namespace :es do
  task create_indices: :environment do
    logger = Logger.new(STDOUT)

    existing_indices = Elasticsearch::Model.client.indices.stats.dig('indices')&.keys&.map(&:to_s)

    concerns = [UserAndPostSearchable]
    concerns.each do |concern|
      concern.create_index! unless existing_indices.include?(concern::INDEX_NAME.to_s)
    rescue StandardError => e
      next logger.error(e)
    end
  end

  task delete_indices: :environment do
    logger = Logger.new(STDOUT)

    client = Elasticsearch::Model.client

    concerns = [UserAndPostSearchable]
    concerns.each do |concern|
      client.indices.delete(index: concern::INDEX_NAME.to_s)
    rescue StandardError => e
      next logger.error(e)
    end
  end
end
