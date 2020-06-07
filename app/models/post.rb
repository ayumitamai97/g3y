# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  content    :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Post < ApplicationRecord
  include Elasticsearch::Model
  include UserAndPostSearchable

  belongs_to :user

  validates :content, presence: true, length: { maximum: 255 }

  JOIN_TYPE = 'post'
  settings do
    mappings do
      indexes :content, analyzer: 'kuromoji', index_options: 'offsets'
    end
  end

  after_commit -> { __elasticsearch__.index_document(routing: user_id) }, on: :create
  after_commit -> { __elasticsearch__.update_document(routing: user_id) }, on: :update
  after_commit -> { __elasticsearch__.delete_document(routing: user_id) }, on: :destroy

  def as_indexed_json(options = {})
    json = as_json(options)[JOIN_TYPE] || as_json(options)
    json.merge(relation_type: { name: JOIN_TYPE, parent: user_id }).deep_stringify_keys
  end
end
