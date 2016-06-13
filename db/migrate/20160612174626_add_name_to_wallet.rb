class AddNameToWallet < ActiveRecord::Migration
  def change
    add_column :wallets, :name, :string, default: "Default"
  end
end
