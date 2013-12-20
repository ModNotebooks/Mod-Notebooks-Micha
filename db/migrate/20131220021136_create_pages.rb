class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.integer :number
      t.string :image
      t.hstore :meta, default: ''
      t.belongs_to :notebook, index: true

      t.timestamps
    end
  end
end
