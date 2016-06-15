class AddPhoneToUsers < ActiveRecord::Migration
  def change
    add_column :users, :phone, :string, default: "", null: false
  end
end
