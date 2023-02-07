# frozen_string_literal: true

# CreateStatuses
class CreateStatuses < ActiveRecord::Migration[7.0]
  def change
    create_table :statuses do |t|
      t.text :body, limit: 300, null: false
      t.references :user
      t.references :status, index: true, foreign_key: { to_table: :statuses }

      t.timestamps
    end
  end
end
