class RemovePaperTypeFromNotebooks < ActiveRecord::Migration
  def change
    remove_column :notebooks, :paper_type, :string
  end
end
