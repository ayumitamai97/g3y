# frozen_string_literal: true

module UserAndPostSearchable
  extend ActiveSupport::Concern

  included do
    index_name INDEX_NAME
  end

  module_function

  INDEX_NAME = "users_and_posts_#{Rails.env}"
  SETTINGS = {
    index: { number_of_shards: 5, number_of_replicas: 0 },
    analysis: { analyzer: 'kuromoji' },
  }.freeze

  def create_index!(options = {})
    delete_index if options.delete(:force)

    settings = User.settings.to_hash.merge(Post.settings.to_hash).merge(SETTINGS)
    index_info = {
      index: INDEX_NAME,
      body: {
        settings: settings.to_hash,
        mappings: { properties: merged_properties },
      },
    }.merge(options)
    elastic_client.indices.create(index_info)
  end

  def delete_index
    elastic_client.indices.delete index: INDEX_NAME
  rescue StandardError
    nil
  end

  def merged_properties
    mapping_properties = {
      relation_type: {
        type: 'join',
        relations: { User::JOIN_TYPE => Post::JOIN_TYPE },
      },
    }

    mapping_properties
      .merge(User.mappings.to_hash[:properties])
      .merge(Post.mappings.to_hash[:properties])
  end

  def elastic_client
    User.__elasticsearch__.client
  end
end
