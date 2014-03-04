class DropNotebookEvents < ActiveRecord::Migration
  def up
    drop_table :notebook_events
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
