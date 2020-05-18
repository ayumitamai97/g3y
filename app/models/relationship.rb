# frozen_string_literal: true

# == Schema Information
#
# Table name: relationships
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  follower_id  :bigint
#  following_id :bigint
#
# Indexes
#
#  index_relationships_on_follower_id                   (follower_id)
#  index_relationships_on_follower_id_and_following_id  (follower_id,following_id) UNIQUE
#  index_relationships_on_following_id                  (following_id)
#
# Foreign Keys
#
#  fk_rails_...  (follower_id => users.id)
#  fk_rails_...  (following_id => users.id)
#
class Relationship < ApplicationRecord
  include Elasticsearch::Model
  include RelationshipSearchable

  belongs_to :follower, class_name: 'User'
  belongs_to :following, class_name: 'User'

  validates :following, :follower, presence: true
  validates :following, uniqueness: { scope: :follower_id, message: 'is already in your followings' }
  validates :following, exclusion: { in: ->(rel) { [rel.follower] } }

  settings do
    mappings dynamic: 'false' do
      indexes :following_name, analyzer: 'trigram', index_options: 'offsets'
      indexes :follower_name, analyzer: 'trigram', index_options: 'offsets'
    end
  end

  after_commit -> { __elasticsearch__.index_document  }, on: :create
  after_commit -> { __elasticsearch__.update_document }, on: :update
  after_commit -> { __elasticsearch__.delete_document }, on: :destroy

  # elasticsearch-model
  def as_indexed_json(options = {})
    as_json(options)
      .merge(follower_name: follower.name, following_name: following.name)
      .deep_stringify_keys
  end
end
