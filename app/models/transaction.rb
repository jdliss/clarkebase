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
    status   = signed.status
    rescue_if_failed unless status == 200
  end

  def rescue_if_failed
    raise ActiveRecord::Rollback
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

    mark_complete(completed)
  end

  def self.mark_complete(completed)
    completed.each do |transaction|
      transaction.completed!
      send_notification(transaction)
    end
  end

  def self.send_notification(transaction)
    to = Wallet.find_by(public_key: transaction.to).user
    unless to.phone.nil? || to.phone.empty?
      from = Wallet.find_by(public_key: transaction.from).user
      MessengerService.send_message(
        "#{from.email} sent you #{pluralize(transaction.amount, "ClarkeCoin")}  on ClarkeBase!",
        to.phone
      )
    end
  end

  private

  def find_pkey(address)
    Wallet.find_by(public_key: address).private_key
  end

  def pluralize(number, text)
    return text.pluralize if number != 1
    text
  end
end
