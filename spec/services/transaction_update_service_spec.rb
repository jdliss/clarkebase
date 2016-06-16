require 'rails_helper'
require 'transaction_update_service'

RSpec.describe TransactionUpdateService do
  it "can collect raw data from the transaction pool" do
    VCR.use_cassette("services/transactions") do
      key           = ENV["PRIVATE_KEY"].dup
      pub           = ENV["PUBLIC_KEY"].dup
      wallet_a      = create(:wallet, private_key: key, public_key: pub)
      user_a        = wallet_a.user
      wallet_b      = create(:wallet)
      user_b        = wallet_b.user
      from_addy     = wallet_a.address
      to_addy       = wallet_b.address
      amount        = 2

      allow_any_instance_of(ClarkeService).to receive(:get_node).and_return("http://159.203.206.61:3000")

      transaction   = Transaction.create(amount: amount, from: from_addy, to: to_addy)

      service = TransactionUpdateService.new

      results  = service.parse_current_pending
      expected = [{
        :signature=>"LDkvSUcZ2HuaJkqzIHyROg7p4gajDkpIqKpryOGouCBB/1z+/r2NCKcr0G2AjSVKISxkF+q0deWKaEihTupgDAJwtkPyKPUkhHyhsHFy+7UlrZ8Szps2rkeF8InbWy7FRm6hG7V6xxsF4VB6HQLA+0lwDA7OmsdmOQHbDab077VJnQZhDQ3xNaJhFcwowrADMa7UJHgJXHqsjLDG8osdJ7Z3HDHJc/8aCAZfrfEQBTIkRxcJdhpCFgTY5UEiq7gau7znQFVPh9EyOUTtO4voiiBlGMyUVmFpekdft5mE8550PajyZsKoo9p7zhIeOn6XHXh5uZbo/9wu9FPwqwT4SA=="}, {:signature=>"IEssBZFxurlNUDohWaRHqIE7cUPdTiFQO4/cyprrjX+njAx68IMCJveC3WIEbdYcWVwxdaAeWXed+pToWc4omnma9KItvfOv6F6oyq7WGEfLHN4oy4DDJOsL929d9lgMop9k3PBK6QR/JhFb4+NrwRdgxuFuyB2QPHIr6qZ/Tf1fHmfQ11Z0Ue31UPjbE0QPFXr+RvDRB6Vv8+vboeaA0vLw+hcQqE5gwuZilQ4q/hOhCwem3KOajYWkLJyB64g5iji5e30Byu+hP48RslJreDMqxQ9NJTKzb2EaZvmNA1jKbrw3vruZUcgsImKgBW0dm/68Ja904nZR788XzcEjrQ=="
      }]

      expect(results).to eq expected
    end
  end
end
