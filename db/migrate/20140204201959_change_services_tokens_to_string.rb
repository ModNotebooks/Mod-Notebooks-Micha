class ChangeServicesTokensToString < ActiveRecord::Migration
  def change
    change_column :services, :token, :string
    change_column :services, :secret, :string
    change_column :services, :refresh_token, :string
  end
end
