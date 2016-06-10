class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :wallets

  def primary_wallet
    self.wallets.where(status: 1).first
  end
end
