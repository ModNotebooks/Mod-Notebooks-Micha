class AddAvailableOnToNotebooks < ActiveRecord::Migration
  def change
    add_column :notebooks, :available_on,  :datetime
    Notebook.processed.map(&:available!)
  end
end
