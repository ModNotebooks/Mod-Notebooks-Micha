class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :type
      t.belongs_to :user
      t.string :provider
      t.string :uid
      t.string :name
      t.string :email
      t.string :nickname
      t.binary :token
      t.binary :secret
      t.binary :refresh_token
      t.datetime :expires_at
      t.datetime :checked_at
      t.datetime :deleted_at
      t.text :delta_cursor
      t.hstore :meta
      t.datetime :disabled_at
      t.string :disabled_reason
      t.hstore :disabled_data

      t.timestamps
    end

    add_index :services, :user_id
    add_index :services, :provider
    add_index :services, :uid
    add_index :services, :meta
  end
end
