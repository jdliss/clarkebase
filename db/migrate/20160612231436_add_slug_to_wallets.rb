class AddSlugToWallets < ActiveRecord::Migration
  def change
    add_column :wallets, :slug, :string
  end
end
