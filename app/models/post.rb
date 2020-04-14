# frozen_string_literal: true

class Post < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :user

  validates :content, presence: true
end
