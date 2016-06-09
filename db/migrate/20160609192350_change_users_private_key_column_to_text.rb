class ChangeUsersPrivateKeyColumnToText < ActiveRecord::Migration
  def change
    change_column :wallets, :private_key, :text
  end
end
