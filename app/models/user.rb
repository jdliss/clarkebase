class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :wallets

  def primary_wallet
    # wallet where enum = primary
    self.wallets.first
  end
end
