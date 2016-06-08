class AddPublicKeyToWallet < ActiveRecord::Migration
  def change
    add_column :wallets, :public_key, :text
  end
end
