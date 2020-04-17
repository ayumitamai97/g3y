# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class User < ApplicationRecord
  include Elasticsearch::Model
  include UserAndPostSearchable

  has_many :posts, dependent: :destroy

  validates :name, presence: true

  # ref. https://github.com/elastic/elasticsearch-rails/blob/master/elasticsearch-model/spec/support/app/parent_and_child_searchable.rb
  JOIN_TYPE = 'user'
  JOIN_METADATA = { relation_type: JOIN_TYPE }.freeze

  after_commit -> { __elasticsearch__.index_document  }, on: :create
  after_commit -> { __elasticsearch__.update_document }, on: :update
  after_commit -> { __elasticsearch__.delete_document }, on: :destroy

  def as_indexed_json(options = {})
    json = as_json(options)[JOIN_TYPE] || as_json(options)
    json.merge(JOIN_METADATA)
  end
end
