class CreateNotebooks < ActiveRecord::Migration
  def change
    create_table :notebooks do |t|
      t.string :name
      t.string :color
      t.string :paper_type
      t.string :carrier_identifier
      t.belongs_to :user
      t.hstore :meta

      t.timestamps
    end

    add_index :notebooks, :user_id
    add_index :notebooks, :carrier_identifier
  end
end
