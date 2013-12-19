class AddPdfToNotebooks < ActiveRecord::Migration
  def change
    add_column :notebooks, :pdf, :string
  end
end
