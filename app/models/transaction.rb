require 'transaction_update_service'

class Transaction < ActiveRecord::Base
  validates_presence_of :from, :to, :amount
  before_create :send_transaction

  enum status: %w(pending completed failed)

  def send_transaction
    pkey     = find_pkey(self.from)
    service  = ClarkeService.new(pkey)
    unsigned = service.parsed_unsigned_payment(self.from, self.to, self.amount)
    signed   = service.parsed_signed_payment(unsigned)
  end

  def email(whom)
    if !Wallet.find_by_public_key(self.send(whom)).nil?
      Wallet.find_by_public_key(self.send(whom)).user.email
    else
      self.send(whom)
    end
  end

  def time
    self.created_at.strftime("%a %b %d, %Y -%l:%M %p")
  end

  def self.update_transactions
    service = TransactionUpdateService.new
    pending_transactions = service.parse_current_pending

    if pending_transactions.empty?
      completed = Transaction.pending
    else
      completed = pending_transactions.map do |pending|
        Transaction.pending.where.not(from: pending[:from], to: pending[:to])
      end.flatten
    end

    completed.each do |transaction|
      transaction.completed!
    end
  end

  private
    def find_pkey(address)
      Wallet.find_by(public_key: address).private_key
    end

    def transaction_service
      TransactionUpdateService.new
    end
end
