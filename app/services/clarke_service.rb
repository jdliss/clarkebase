class ClarkeService

  def initialize(user=nil)
    @user = user
    @connection = Faraday.new(url: 'http://159.203.206.61:3000')
  end

  def get_balance(address)
    @connection.post do |req|
      req.url '/balance'
      req.headers['Content-Type'] = 'application/json'
      req.body = "{ \"address\": \"#{address}\" }"
    end
  end

  def get_unsigned_payment(data)
    @connection.post do |req|
      req.url '/unsigned_payment_transactions'
      req.headers['Content-Type'] = 'application/json'
      req.body = data
    end
  end

  def parsed_unsigned_payment(from, to, amount, fee)
    parse_result(get_unsigned_payment(unsigned_args(from, to, amount, fee)))
  end

  def unsigned_args(from, to, amount, fee)
    {
      from_address: from,
      to_address: to,
      amount: amount,
      fee: fee,
    }.to_json
  end

  def parsed_balance(address)
    result = parse_result(get_balance(address))
    result.dig("payload", "balance")
  end

  def submit_transaction(signed_transaction)
    @connection.post do |req|
      req.url '/pending_transactions'
      req.headers['Content-Type'] = 'application/json'
      req.body = signed_transaction.to_json
    end
  end

  def parsed_signed_payment(unsigned)
    hashable_transactions_string = flatten_values(unsigned).join

    digest = OpenSSL::Digest::SHA256.new
    pkey = OpenSSL::PKey::RSA.new(@user.wallet.private_key)
    signature = pkey.sign digest, hashable_transactions_string
    unsigned["payload"]["inputs"].first["signature"] = Base64.encode64(signature)
    signed = unsigned["payload"]
    binding.pry
    submit_transaction(signed)
  end

  def flatten_values(nest)
    nest.values.flatten(-1).map{|e| e.is_a?(Hash) ? flatten_values(e) : e.to_s}.flatten
  end

  private

    def parse_result(data)
      JSON.parse(data.body)
    end
end
