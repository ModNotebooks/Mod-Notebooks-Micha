class AddDefaultValuesToHstoreColumns < ActiveRecord::Migration
  def change
    change_column :users, :meta, :hstore, default: '', null: false
    change_column :notebooks, :meta, :hstore, default: '', null: false
  end
end
