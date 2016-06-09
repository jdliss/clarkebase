require 'pkey_service'

class Wallet < ActiveRecord::Base
  belongs_to  :user
  before_save :generate_keys

  def generate_keys
    key_service = PKeyService.new
    self.private_key ||= key_service.generate_private_key
    self.public_key  ||= key_service.public_key
  end

  def address
    clean_public_key
  end

  def balance
    clarke_service.parsed_balance(address)
  end

  def clean_public_key
    key = self.public_key
    key.slice!("-----BEGIN RSA PRIVATE KEY-----")
    key.slice!("-----END RSA PRIVATE KEY-----")
    key.gsub!("\\n", "")
    key.gsub!("\n", "")
  end

private

  def clarke_service
    ClarkeService.new
  end
end
