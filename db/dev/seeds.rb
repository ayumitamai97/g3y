# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

now = Time.zone.now

user_attributes = 50.times.map do
  { name: Faker::Name.name, created_at: now, updated_at: now }
end
User.insert_all(user_attributes)
User.import

post_attributes = User.find_each.map do |user|
  3.times.map do
    {
      user_id: user.id,
      content: Faker::Lorem.sentence(word_count: 5),
      created_at: now,
      updated_at: now
    }
  end
end.flatten
Post.insert_all(post_attributes)
Post.import
