class Transaction < ActiveRecord::Base
  validates_presence_of :from, :to, :amount
  before_save :send_transaction

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

  def update_transaction
    pending_transactions = transaction_service.parse_current_pending

    still_pending = pending_transactions.map do |pending|
      Transaction.pending.find_by(from: pending[:from], to: pending[:to])
    end

    not_pending = Transaction.pending - still_pending

    not_pending.each do |transaction|
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
