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

  belongs_to :user

  validates :content, presence: true

  JOIN_TYPE = 'post'

  index_name 'users_and_posts'

  mapping do
    indexes :content
  end

  def as_indexed_json(options = {})
    # This line is necessary for differences between ActiveModel::Serializers::JSON#as_json versions
    json = as_json(options)[JOIN_TYPE] || as_json(options)
    json.merge(join_field: { name: JOIN_TYPE, parent: user_id })
  end

  after_commit -> { __elasticsearch__.index_document(routing: user_id) }, on: :create
  after_commit -> { __elasticsearch__.update_document(routing: user_id) }, on: :update
  after_commit -> { __elasticsearch__.delete_document(routing: user_id) }, on: :destroy

  mapping do
    indexes :content
  end

  def as_indexed_json(options = {})
    json = as_json(options)[JOIN_TYPE] || as_json(options)
    json.merge(join_field: { name: JOIN_TYPE, parent: user_id })
  end
end
