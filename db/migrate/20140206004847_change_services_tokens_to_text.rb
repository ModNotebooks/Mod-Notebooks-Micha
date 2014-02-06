class ChangeServicesTokensToText < ActiveRecord::Migration
  def change
    change_column :services, :token, :text
    change_column :services, :secret, :text
    change_column :services, :refresh_token, :text
  end
end
