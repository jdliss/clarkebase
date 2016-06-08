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

  def parsed_balance(address)
    result = parse_result(get_balance(address))
    result.dig("payload", "balance")
  end

  private
    def parse_result(data)
      JSON.parse(data.body)
    end
end
