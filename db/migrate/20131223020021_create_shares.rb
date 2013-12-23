class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
      t.string :token
      t.references :shareable, polymorphic: true
      t.timestamps
    end

    add_index :shares, [:shareable_id, :shareable_type]
    add_index :shares, :token
  end
end
