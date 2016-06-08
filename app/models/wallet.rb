require 'pkey_service'

class Wallet < ActiveRecord::Base
  belongs_to :user
  before_save :generate_private_key

  def generate_private_key
    self.private_key ||= PKeyService.generate_private_key
  end

  def address
    public_key_der = PKeyService.public_key(self.private_key)
    Base64.encode64(public_key_der)
  end

  def balance
    # need to refactorlactor
    conn = Faraday.new(url: 'http://159.203.206.61:3000')

    post_result = conn.post do |req|
      req.url '/balance'
      req.headers['Content-Type'] = 'application/json'
      req.body = "{ \"address\": \"#{address}\" }"
    end

    result_body = JSON.parse(post_result.body)
    result_body.dig("payload", "balance")
  end
end
