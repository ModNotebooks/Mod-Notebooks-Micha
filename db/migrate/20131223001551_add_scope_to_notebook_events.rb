class AddScopeToNotebookEvents < ActiveRecord::Migration
  def change
    add_column :notebook_events, :scope, :string
  end
end
