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
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'factory' do
    context 'valid' do
      it { expect { create(:user) }.not_to raise_error }
      it { expect { create(:user) }.to change { User.count }.by 1 }
    end

    context 'invalid' do
      it 'raises error and does not increment count' do
        user = build(:user, name: '', email: 'test@example.com', password: 'password')
        expect(user.save).to eq false
        expect { user.save }.not_to(change { User.count })
        expect { user.save! }.to raise_error ActiveRecord::RecordInvalid
      end

      it 'raises error and does not increment count' do
        user = build(:user, name: 'test', email: 'test', password: 'password')
        expect(user.save).to eq false
        expect { user.save }.not_to(change { User.count })
        expect { user.save! }.to raise_error ActiveRecord::RecordInvalid
      end

      it 'raises error and does not increment count' do
        user = build(:user, name: 'test', email: 'test@example.com', password: '')
        expect(user.save).to eq false
        expect { user.save }.not_to(change { User.count })
        expect { user.save! }.to raise_error ActiveRecord::RecordInvalid
      end
    end
  end

  describe '#follow' do
    let!(:follower_user) { create(:user) }
    let!(:followed_user) { create(:user) }

    it 'increases Relationship.count' do
      expect { follower_user.follow(user: followed_user) }.to change { Relationship.count }.by 1
    end

    it 'increases Relationship.count' do
      follower_user.follow(user: followed_user)
      expect(follower_user.followings).to include followed_user
      expect(followed_user.followers).to include follower_user
    end
  end
end
