class UpdateDoorkeeperTables < ActiveRecord::Migration
  def change
    change_column :oauth_access_tokens, :application_id, :integer, null: true
  end
end
