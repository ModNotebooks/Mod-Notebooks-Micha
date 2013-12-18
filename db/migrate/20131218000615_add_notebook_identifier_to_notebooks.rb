class AddNotebookIdentifierToNotebooks < ActiveRecord::Migration
  def change
    add_column :notebooks, :notebook_identifier, :string
    add_index :notebooks, :notebook_identifier, unique: true
  end
end
