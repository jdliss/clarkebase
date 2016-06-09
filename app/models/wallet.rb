require 'pkey_service'

class Wallet < ActiveRecord::Base
  belongs_to  :user
  before_save :generate_keys

  def generate_keys
    key_service = PKeyService.new
    self.private_key ||= key_service.generate_private_key
    self.public_key ||= key_service.public_key
  end

  def address
    self.public_key.gsub("\n", "")
    # remove "----BEGIN"
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
