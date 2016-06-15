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
      result = transactions['payload'].map do |payload_item|
        data = payload_item['outputs'].flatten
        { from: data.first['address'], to: data.last['address'] }
      end
    end
  end

end
