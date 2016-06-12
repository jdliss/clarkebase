class Transaction < ActiveRecord::Base
  validates_presence_of :from, :to, :amount, :wallet_id
  before_save :send_transaction
  belongs_to :wallet

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

  def to_email
    Wallet.find_by_public_key(self.to).user.email
  end

end
