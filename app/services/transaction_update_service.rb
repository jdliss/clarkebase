class TransactionUpdateService

  def initialize(key=nil)
    @sigkey  = key
    @connection = Faraday.new(url: get_node)
  end

  def get_node
    service = NodeService.new
    active_nodes = service.parse_node
    node = service.get_url(active_nodes)
  end

  def current_pending
    @connection.get do |req|
      req.url '/pending_transactions'
      req.headers['Content-Type'] = 'application/json'
    end
  end

  def parse_current_pending
    if Transaction.pending.any?
      transactions = JSON.parse(current_pending.body)
      transactions['payload'].map do |payload_item|
        { signature: payload_item["inputs"].first["signature"] }
      end
    else
      []
    end
  end

end
