class AddStateToNotebooks < ActiveRecord::Migration
  def change
    add_column :notebooks, :state, :string
  end
end
