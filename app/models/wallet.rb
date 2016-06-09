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
    Wallet.clean_key(self.public_key)
  end

  def db_public_key
    new_lined = public_key.chars.each_slice(64).map(&:join).join("\n")
    "-----BEGIN RSA PUBLIC KEY-----\n" + new_lined + "\n-----END RSA PUBLIC KEY-----\n"
  end

  def self.db_private_key(pkey)
    new_lined = pkey.chars.each_slice(64).map(&:join).join("\n")
    "-----BEGIN RSA PRIVATE KEY-----\n" + new_lined + "\n-----END RSA PRIVATE KEY-----\n"
  end


  def balance
    clarke_service.parsed_balance(address)
  end

private

  def clarke_service
    ClarkeService.new
  end

  def self.clean_key(key)
    key.slice!("-----BEGIN PUBLIC KEY-----")
    key.slice!("-----END PUBLIC KEY-----")
    key.slice!("-----BEGIN RSA PRIVATE KEY-----")
    key.slice!("-----END RSA PRIVATE KEY-----")
    key.gsub!("\\n", "")
    key.gsub!("\n", "")
  end
end
