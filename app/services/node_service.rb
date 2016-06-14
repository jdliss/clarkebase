class NodeService

  def initialize
    @connection = Faraday.new(url: 'http://dns1.clarkecoin.org')
  end

  def get_node
    @connection.get do |req|
      req.url '/api/peers'
      req.headers['Content-Type'] = 'application/json'
    end
  end

  def parse_node
    JSON.parse(get_node.body)
  end

  def get_url(nodes)
    node  = nodes.sample
    "http://#{node.dig("host")}:#{node.dig("port")}"
  end
end
