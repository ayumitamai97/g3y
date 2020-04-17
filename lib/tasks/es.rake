namespace :es do
  task create_indices: :environment do
    existing_indices = Elasticsearch::Model.client.indices.stats.dig('indices')&.keys.map(&:to_s)

    logger = Logger.new(STDOUT)

    concerns = [UserAndPostSearchable]
    concerns.each do |concern|
      concern.create_index! if existing_indices.include?(concern::INDEX_NAME.to_s)
    rescue StandardError => e
      next logger.error(e)
    end
  end
end
