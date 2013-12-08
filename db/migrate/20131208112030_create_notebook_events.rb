class CreateNotebookEvents < ActiveRecord::Migration
  def change
    create_table :notebook_events do |t|
      t.belongs_to :notebook
      t.string :state
      t.timestamps
    end

    add_index :notebook_events, :notebook_id
  end
end
