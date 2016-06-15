class AddSignatureToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :signature, :text
  end
end
