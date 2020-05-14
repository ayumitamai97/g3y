# frozen_string_literal: true

class CreateRelationships < ActiveRecord::Migration[6.0]
  def change
    create_table :relationships do |t|
      t.references :follower, index: true, foreign_key: { to_table: :users }
      t.references :following, index: true, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :relationships, %i[follower_id following_id], unique: true
  end
end
