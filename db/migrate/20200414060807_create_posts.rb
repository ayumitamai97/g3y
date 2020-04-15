# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.string :content, null: false

      t.timestamps
    end
  end
end
