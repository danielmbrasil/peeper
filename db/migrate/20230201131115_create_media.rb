# frozen_string_literal: true

# CreateMedia
class CreateMedia < ActiveRecord::Migration[7.0]
  def change
    create_table :media do |t|
      t.integer :medium_type, null: false
      t.string :url, null: false

      t.belongs_to :status, index: true, foreign_key: true

      t.timestamps
    end
  end
end
