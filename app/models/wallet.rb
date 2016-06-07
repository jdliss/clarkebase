require_relative '../services/pkey_service'

class Wallet < ActiveRecord::Base
  belongs_to :user

  def private_key
    PKeyService.generate_private_key
  end
end
