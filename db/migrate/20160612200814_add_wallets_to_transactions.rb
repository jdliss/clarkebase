class AddWalletsToTransactions < ActiveRecord::Migration
  def change
    add_reference :transactions, :wallet, index: true, foreign_key: true
  end
end
