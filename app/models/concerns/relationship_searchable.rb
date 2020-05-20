# frozen_string_literal: true

module RelationshipSearchable
  extend ActiveSupport::Concern

  included do
    index_name INDEX_NAME
  end

  module_function

  INDEX_NAME = "followings_#{Rails.env}"
  SETTINGS = {
    index: { number_of_shards: 5, number_of_replicas: 0 },
    analysis: {
      analyzer: {
        trigram: {
          tokenizer: 'trigram',
        },
      },
      tokenizer: {
        trigram: {
          type: 'ngram',
          min_gram: 3,
          max_gram: 4,
          token_chars: %w[letter digit],
        },
      },
    },
  }.freeze

  def create_index!(options = {})
    delete_index if options.delete(:force)

    settings = Relationship.settings.to_hash.merge(SETTINGS)
    index_info = {
      index: INDEX_NAME,
      body: {
        settings: settings.to_hash,
        mappings: {
          properties: Relationship.mappings.to_hash[:properties],
        },
      },
    }.merge(options)
    elastic_client.indices.create(index_info)
  end

  def delete_index
    elastic_client.indices.delete index: INDEX_NAME
  rescue StandardError
    nil
  end

  def elastic_client
    Relationship.__elasticsearch__.client
  end
end
