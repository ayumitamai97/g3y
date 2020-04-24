# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string(255)      default(""), not null
#  name            :string(255)      not null
#  password_digest :string(255)      default(""), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#  index_users_on_name   (name) UNIQUE
#
class User < ApplicationRecord
  include Elasticsearch::Model
  include UserAndPostSearchable

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  has_secure_password

  has_many :posts, dependent: :destroy

  validates :name, :email, presence: true
  validates :name,
            uniqueness: { case_sensitive: false },
            format: { with: /\w+/, message: 'should be alphanumerical' },
            allow_blank: true
  validates :email,
            uniqueness: { case_sensitive: false },
            format: { with: VALID_EMAIL_REGEX, message: 'should be properly formatted like name@example.com' },
            allow_blank: true
  validates :password, length: { minimum: 8 }

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
