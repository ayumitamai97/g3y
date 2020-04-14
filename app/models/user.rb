class User < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  has_many :posts, dependent: :destroy

  validates :name, presence: true
end
