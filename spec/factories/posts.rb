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
require 'faker'

FactoryBot.define do
  factory :post do
    user
    content { "#{Faker::Science.scientist} #{Faker::Verb.base}" }
  end
end
