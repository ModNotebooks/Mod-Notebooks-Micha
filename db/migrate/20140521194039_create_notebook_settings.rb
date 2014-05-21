class CreateNotebookSettings < ActiveRecord::Migration
  def change
    create_table :notebook_settings do |t|
      t.string :name
      t.string :color_code
      t.string :color
      t.string :cover_image

      t.timestamps
    end
  end
end
