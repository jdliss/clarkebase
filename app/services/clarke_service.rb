class ClarkeService

  def initialize(user=nil)
    @user = user
    @connection = Faraday.new(url: 'http://159.203.206.61:3000')
  end

  def get_balance(address, , , )
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

  def parsed_unsigned_payment(from, to, amount, fee=0)
    parse_result(get_unsigned_payment(unsigned_args(from, to, amount, fee)))
  end

  def unsigned_args(from, to, amount, fee)
    {
      from_address: from,
      to_address:   to,
      amount:       amount,
      fee:          fee,
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
    digest    = OpenSSL::Digest::SHA256.new
    pkey      = OpenSSL::PKey::RSA.new(KeyCleanerService.private_strict_format(@user.primary_wallet.private_key))
    signature = pkey.sign digest, signable_string(unsigned)
    unsigned["payload"]["inputs"].first["signature"] = Base64.encode64(signature).gsub("\n", "")
    signed = unsigned["payload"]

    submit_transaction(signed)
  end

  def signable_string(unsigned)
    transaction = unsigned["payload"]
    inputs      = transaction["inputs"].map { |i| i["source-hash"] + i["source-index"].to_s}.join
    outputs     = transaction["outputs"].map { |i| i["amount"].to_s + i["address"] }.join
    timestamp   = transaction["timestamp"].to_s
    min_height  = transaction["min-height"].to_s

    inputs + outputs + min_height + timestamp
  end

  private

    def parse_result(data)
      JSON.parse(data.body)
    end
end
