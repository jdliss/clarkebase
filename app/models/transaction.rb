class Transaction < ActiveRecord::Base
  validates_presence_of :from, :to, :amount
  before_save :send_transaction

  def find_user(address)
    Wallet.find_by(public_key: address).user
  end

  def send_transaction
    user = find_user(self.from)
    service = ClarkeService.new(user)
    unsigned = service.parsed_unsigned_payment(user.wallet.address, self.to, self.amount)
    signed = service.parsed_signed_payment(unsigned)
  end

end
