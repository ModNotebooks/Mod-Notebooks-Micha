class AddPagesCountToNotebook < ActiveRecord::Migration
  def change
    add_column :notebooks, :pages_count, :integer, default: 0
  end
end
