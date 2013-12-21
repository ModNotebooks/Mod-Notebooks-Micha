class AddDeletedAtToNotebooks < ActiveRecord::Migration
  def change
    add_column :notebooks, :deleted_at, :datetime
  end
end
