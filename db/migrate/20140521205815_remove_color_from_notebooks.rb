class RemoveColorFromNotebooks < ActiveRecord::Migration
  def change
    remove_column :notebooks, :color, :string
  end
end
