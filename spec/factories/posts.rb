require 'faker'

FactoryBot.define do
  factory :post do
    user
    content { "#{Faker::Science.scientist} #{Faker::Verb.base}" }
  end
end
