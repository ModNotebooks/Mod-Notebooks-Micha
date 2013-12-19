class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.hstore :meta, {}

      t.timestamps
    end
  end
end
