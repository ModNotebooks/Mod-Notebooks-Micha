class CreatePreferences < ActiveRecord::Migration
  def change
    create_table :preferences do |t|
      t.hstore :properties, {}
      t.belongs_to :user
      t.timestamps
    end

    add_index :preferences, :user_id, unique: true
  end
end
