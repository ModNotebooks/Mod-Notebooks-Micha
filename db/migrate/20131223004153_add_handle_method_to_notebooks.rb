class AddHandleMethodToNotebooks < ActiveRecord::Migration
  def change
    add_column :notebooks, :handle_method, :string
  end
end
