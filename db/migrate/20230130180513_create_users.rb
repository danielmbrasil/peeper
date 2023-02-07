# frozen_string_literal: true

# CreateUsers
class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :handle, null: false, unique: true, limit: 12
      t.string :display_name, null: false, limit: 30
      t.text :bio, limit: 300
      t.date :born_at, null: false

      t.timestamps
    end
  end
end
