class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.references :addressable, polymorphic: true
      t.string :name
      t.string :line_1
      t.string :line_2
      t.string :city
      t.string :region
      t.string :postal_code
      t.string :country
      t.timestamps
    end

    add_index :addresses, [:addressable_id, :addressable_type]
  end
end
