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

  def balance
    clarke_service.parsed_balance(address)
  end

  def self.clean_input_key(key)
    key.slice!("-----BEGIN RSA PRIVATE KEY-----")
    key.slice!("-----END RSA PRIVATE KEY-----")
    key.gsub!("\\n", "")
    key.gsub!("\n", "")
    Base64.decode64(key)
  end

private

  def clarke_service
    ClarkeService.new
  end
end
