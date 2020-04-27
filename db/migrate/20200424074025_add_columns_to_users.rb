# frozen_string_literal: true

class AddColumnsToUsers < ActiveRecord::Migration[6.0]
  def change
    change_table :users, bulk: true do |t|
      t.index :name, unique: true
      t.string :email, null: false, index: { unique: true }, default: ''
      t.string :password_digest, null: false, default: ''
    end
  end
end
