require 'pkey_service'

class Wallet < ActiveRecord::Base
  belongs_to :user
  before_save :generate_private_key
  before_save :generate_public_key

  def generate_private_key
    self.private_key ||= PKeyService.generate_private_key
  end

  def generate_public_key
    self.public_key ||= PKeyService.public_key(self.private_key).gsub("\n", "")
  end

  def address
    self.public_key
  end

  def db_public_key
    binding.pry
    new_lined = public_key.chars.each_slice(64).map(&:join).join("\n")
    "-----BEGIN RSA PUBLIC KEY-----\n" + new_lined + "\n-----END RSA PUBLIC KEY-----\n"
  end

  def balance
    clarke_service.parsed_balance(address)
  end

  private
    def clarke_service
      ClarkeService.new
    end
end
