require 'rails_helper'
require 'transaction_update_service'

RSpec.describe TransactionUpdateService do
  it "can collect raw data from the transaction pool" do
    VCR.use_cassette("services/transactions", record: :new_episodes) do
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
        :signature=>"h3pQE8o9Btz0JW28U/4Aj1RglQIHOFC0evUKEE3eAnp6/XEEHdVrJY7+/zbwIbCGJG5va3hDc1gIp3SY0iiyPq9Idii3Sdq11tNDFKY00Jf0nUKc3pARnGqG6xSF0YrMGF1ozZV/4T5lJN5o/dIAbQwg3XayT9lUoxTCAEKjpXzDfIv4U9lK/md3e1IiLQXEwvo1XtsG5SmXC4fgT0VD1DoVdT88ILbMCMaskyGz9ntZ8P+N8y8kRK0PKi6gV2HSycEsEaTa7xH/lKWRCClCShoc0olrpnPSY/ZRi279x+nnS8cJYcsROYos40q2p7YOVkOpQ2AcSYVH1bYc1PZOSg=="},
        {:signature=>"OFi0b2yVZJV4VQivF9QOs4NPIAETbGOq5YajQk7zneidK2kFwuY++HM5yatH5ARKiKVaiHr9ZUvLvsRo4joieQ84L/EXgqCWdIr/VfE/A63k8OczyzHZWd2qq6dmOGNe8xqvWyZUvmoNCKBgPuxnhC9V0PC9aopm0ZsEV443b/RDZM5Kjsz4IAZptdeLYOPbx5V/Ff8/XGJS8jtFQTd953MNLZQ+uiY04I+j/djJ3weM7zbyy5AxM1WimCtvqU/kIX59L3Jn02cv4RIvwUClsFUSYwk9XD8ofbqB8vSQpxKSxmjhzmLLrwNxerHVYHPVUUUOIz8li7Zp7T0wc6F6Dg=="
      }]

      expect(results).to eq expected
    end
  end
end
