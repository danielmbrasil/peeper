# frozen_string_literal: true

class RenameStatusesStatusIdColumnName < ActiveRecord::Migration[7.0]
  def change
    rename_column :statuses, :status_id, :parent_id
  end
end
