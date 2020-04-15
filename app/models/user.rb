# frozen_string_literal: true

class User < ApplicationRecord
  include Elasticsearch::Model

  has_many :posts, dependent: :destroy

  validates :name, presence: true

  # ref. https://github.com/elastic/elasticsearch-rails/blob/master/elasticsearch-model/spec/support/app/parent_and_child_searchable.rb
  JOIN_TYPE = 'user'
  JOIN_METADATA = { join_field: JOIN_TYPE }.freeze

  index_name 'users_and_posts'

  mapping do
    indexes :name
  end

  def as_indexed_json(options = {})
    json = as_json(options)[JOIN_TYPE] || as_json(options)
    json.merge(JOIN_METADATA)
  end

  after_commit -> { __elasticsearch__.index_document  }, on: :create
  after_commit -> { __elasticsearch__.update_document }, on: :update
  after_commit -> { __elasticsearch__.delete_document }, on: :destroy
end
