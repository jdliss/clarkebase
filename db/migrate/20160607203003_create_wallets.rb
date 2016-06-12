class CreateWallets < ActiveRecord::Migration
  def change
    create_table :wallets do |t|
      t.references :user, index: true, foreign_key: true
      t.text :private_key
      t.integer :status, default: 0

      t.timestamps null: false
    end
  end
end
