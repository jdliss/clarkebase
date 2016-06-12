require "faraday"

module GetPendingTransactions

  def get_pending_transactions
    response = Faraday.get("http://159.203.206.61:3000/pending_transactions")
    parsed = JSON.parse(response.body)
    parsed["payload"].first["outputs"]
  end

end

RSpec.configure do |config|
  config.include GetPendingTransactions, type: :feature
end
