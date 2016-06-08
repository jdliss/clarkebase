require 'pkey_service'

class Wallet < ActiveRecord::Base
  belongs_to :user
  before_save :generate_private_key

  def generate_private_key
    self.private_key ||= PKeyService.generate_private_key
  end

  def address
    public_key_der = PKeyService.public_key(self.private_key)
    Base64.encode64(public_key_der)
  end

  def balance
    clarke_service.parsed_balance(address)
  end

  private
    def clarke_service
      ClarkeService.new
    end
end
