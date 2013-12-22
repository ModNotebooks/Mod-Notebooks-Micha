class RenameNumberToIndexOnPages < ActiveRecord::Migration
  def change
    rename_column :pages, :number, :index
  end
end
