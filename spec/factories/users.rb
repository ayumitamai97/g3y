# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  avatar_key      :string(255)
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
FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user_#{n}" }
    email { "#{name}@example.com" }
    password { "pw_#{name}" }
  end
end
