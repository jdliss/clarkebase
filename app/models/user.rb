class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :friends,
    class_name: "User",
    join_table: :friendships,
    foreign_key: :user_id,
    association_foreign_key: :friend_user_id

  has_many :wallets

  def primary_wallet
    self.wallets.where(status: 1).first
  end
end
