require 'pkey_service'
require 'keycleaner_service'

class Wallet < ActiveRecord::Base
  belongs_to  :user
  before_save :generate_keys, :assign_slug

  enum status: %w(basic primary)

  def generate_keys
    key_service = PKeyService.new
    self.private_key ||= key_service.private_key
    # refactor to delete the newlines in PKeyService
    self.private_key = self.private_key.delete("\n")
    self.public_key ||= key_service.public_key(self.private_key).delete("\n")
  end

  def address
    self.public_key
  end

  def balance
    clarke_service.parsed_balance(address)
  end

  def to_param
    slug
  end

  def assign_slug
    self.slug ||= name.parameterize if name
  end

  def balance_with_id
    "#{name} - CLC: #{balance}"
  end

  def self.all_sent_transactions(wallets)
    wallets.map do |wallet|
      wallet.sent_transactions
    end.flatten
  end

  def self.all_received_transactions(wallets)
    wallets.map do |wallet|
      wallet.received_transactions
    end.flatten
  end

  def sent_transactions
    Transaction.where(from: self.public_key)
  end

  def received_transactions
    Transaction.where(to: self.public_key)
  end

private

  def clarke_service
    ClarkeService.new
  end

end
