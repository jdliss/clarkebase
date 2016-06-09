class ClarkeService

  def initialize
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
    thing = @connection.post do |req|
      req.url '/unsigned_payment_transactions'
      req.headers['Content-Type'] = 'application/json'
      req.body = data
    end
  end

  def parsed_unsigned_payment(from, to, amount, fee)
    result = parse_result(get_unsigned_payment(unsigned_args(from, to, amount, fee)))
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


  private

    def parse_result(data)
      JSON.parse(data.body)
    end
end
