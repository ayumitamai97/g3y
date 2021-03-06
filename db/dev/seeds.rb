# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

Elasticsearch::DeleteIndicesService.new.execute
Elasticsearch::CreateIndicesService.new.execute
sleep 3

5.times do
  User.create(
    name: Faker::Internet.username(separators: ['_']),
    email: Faker::Internet.email,
    password: Faker::Number.number(digits: 8).to_s
  )
end

User.find_each do |user|
  5.times do
    user.posts.create!(content: Faker::Lorem.sentence(word_count: 5))
  end
end

User.find(1).follow(user: User.find(2))

Elasticsearch::Model.client.indices.flush
