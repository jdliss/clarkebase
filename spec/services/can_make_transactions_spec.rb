describe "can get unsigned payment transactions" do
  it "can get unsigned" do
    VCR.use_cassette('transactions') do

      wallet_a, wallet_b = create_list(:wallet, 2)

      from_addy = wallet_a.public_key
      to_addy = wallet_b.public_key
      amount = 2
      fee = 0

      post = ClarkeService.new.parsed_unsigned_payment(from_addy, to_addy, amount, fee)

      # expect(response).to eq 200

      expect(post).to eq({
        "message": "unsigned_transaction",
        "payload": {
          "hash": "9f2461d8cd782bc299d8433796d0d647f5aa29ab9bb8d85442494bcfb9ad04ba",
          "min-height": 294,
          "timestamp": 1465427106662,
          "inputs": [],
          "outputs": [
            {
              "amount": 0,
              "address": "string",
              "coords": {
                "transaction-id": "9f2461d8cd782bc299d8433796d0d647f5aa29ab9bb8d85442494bcfb9ad04ba",
                "index": 0
              }
            }
          ]
        }
      })
    end
  end
end
