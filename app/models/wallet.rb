class Wallet < ActiveRecord::Base
  belongs_to :user
  before_save :generate_private_key

  def generate_private_key
    self.private_key ||= PKeyService.generate_private_key
  end
end
