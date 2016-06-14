require 'rails_helper'

describe "can get node" do
  it "can get a node when we GET http://dns1.clarkecoin.org/api/peers" do
    VCR.use_cassette("services/node") do

      service = NodeService.new
      nodes = service.parse_node
      expect(nodes).to eq([
        {"port"=>3000, "host"=>"159.203.206.61"},
        {"port"=>3000, "host"=>"159.203.206.63"},
        {"port"=>3000, "host"=>"159.203.206.49"}
      ])

      node = service.get_url(nodes)
      host = node[7..-6]
      port = node[-4..-1]

      expect(nodes).to include ({"port"=>port.to_i, "host"=>host})
    end
  end
end
