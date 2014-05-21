class AddMetaToNotebookSetting < ActiveRecord::Migration
  def change
    add_column :notebook_settings, :meta, :hstore
  end
end
