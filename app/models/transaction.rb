class Transaction < ActiveRecord::Base
  validates_presence_of :from, :to, :amount
  before_save :send_transaction

  enum status: %w(pending completed failed)

  def find_user(address)
    Wallet.find_by(public_key: address).user
  end

  def send_transaction
    user     = find_user(self.from)
    service  = ClarkeService.new(user)
    unsigned = service.parsed_unsigned_payment(user.primary_wallet.address, self.to, self.amount)
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
end
