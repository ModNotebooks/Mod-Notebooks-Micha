class AddPagesCountToNotebook < ActiveRecord::Migration
  def change
    add_column :notebooks, :pages_count, :integer, default: 0

    Notebook.reset_column_information
    Notebook.all.each do |n|
      Notebook.update_counters n.id, pages_count: n.pages.length
    end
  end
end
