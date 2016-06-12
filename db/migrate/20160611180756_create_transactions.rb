class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :status, default: 0
      t.integer :amount
      t.text    :from
      t.text    :to

      t.timestamps null: false
    end
  end
end
