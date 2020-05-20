# frozen_string_literal: true

class AddAvatarKeyToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :avatar_key, :string, null: true, after: :password_digest
  end
end
