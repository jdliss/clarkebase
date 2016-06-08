require 'pkey_service'

class Wallet < ActiveRecord::Base
  belongs_to :user
  before_save :generate_private_key
  before_save :generate_public_key

  def generate_private_key
    self.private_key ||= PKeyService.generate_private_key
  end

  def generate_public_key
    self.public_key ||= PKeyService.public_key(self.private_key)
  end

  def address
    self.public_key
  end

  def balance
    stripped_address = address.gsub("\n", "")
    clarke_service.parsed_balance(stripped_address)
  end

  private
    def clarke_service
      ClarkeService.new
    end
end
