class AddDeletedAtToNotebookEvents < ActiveRecord::Migration
  def change
    add_column :notebook_events, :deleted_at, :datetime
  end
end
