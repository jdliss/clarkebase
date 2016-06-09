require 'rails_helper'
include ControllerHelpers

describe "can get unsigned payment transactions" do
  it "can get unsigned" do
    VCR.use_cassette('transactions/unsigned') do

      key      = ENV["PRIVATE_KEY"].dup
      db_key   = Wallet.db_private_key(key)
      wallet_a = create(:wallet, private_key: db_key)
      wallet_b = create(:wallet)

      from_addy = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApoZWMmLesLbU/mTuknlfJx5n9zk1nUmLjvdgxw4iBB0qlcA0ShENeV1UFb6Jcke2OTZ60FgVE+ku8LE0MTBE9YV4lAd4qE3X1O9NQHWnelhNrnTNQXsRoXLXj9euz9St7fbg8+4lxekpnPGAPDt676TMnvDIHnn0RjuBk+zH97LcRuR/i1pstgiPnCh8TBivLz1/dzGdBZ8dvJ+pBrUuHcPopmclN5BKqjAOW1llqGRFta/JP8br8hq4YmgC37bx/C6T6Z7rawTy8FROaGoIHo4xQuT6zNqDW8HGLPRy70BVP7VJC3iJtpNwjCBnYzUSmjoMPY8vRctSUEIHWwzodwIDAQAB"
      to_addy   = wallet_b.address
      amount    = 2
      fee       = 0

      post = ClarkeService.new.parsed_unsigned_payment(from_addy, to_addy, amount, fee)

      expect(post).to eq(
      {
        "message" => "unsigned_transaction",
          "payload" =>
            {
              "hash"=>"e774950c5da53e9ff182523fb6c63591ff5108e4cda6e011870e6fc4863f212a",
              "min-height"=>311, "timestamp"=>1465437474376,
              "inputs"=> [
                {
                  "source-hash"=>"2147c1b38df92f5b7a330522bdf837353b799893f8ff4c9d2b2edc521759234c",
                  "source-index"=>0}],
                  "outputs"=> [{"amount"=>2,
              "address"=>"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqanzFaw1wztAtlzzY3DnBDgV1bWQgXICO12G1/AOQ7t6DVtdqf6fEtNWU1Eg1Fz88HZpWDReAfVTjPERjw5oKEthftLQBbk5AiO3CE3GsGntMyxRBlCPRO1nJms5aqXIao0Vyxsi4TtZggeX84iUOWmz/GQhfCFsMGlOZuGa5Ba7bFTyjC+qH8VsiUr4OqPq09dUl5bohkFbwilv0LoxmIC0yT1bEvEnIXGip66SBjwfMasUrdZRTvAfxVYQGJyOmqtpHiQh5xQASDT8bMDdlZFC0M+/9TXe3PjZoBHdysMTXenjpvBjAmCnp1jkFbmkDsL+3gE2uCYL54hGrpLbIQIDAQAB",
              "coords"=>{"transaction-id"=>"e774950c5da53e9ff182523fb6c63591ff5108e4cda6e011870e6fc4863f212a", "index"=>0}}, {"amount"=>23, "address"=>"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApoZWMmLesLbU/mTuknlfJx5n9zk1nUmLjvdgxw4iBB0qlcA0ShENeV1UFb6Jcke2OTZ60FgVE+ku8LE0MTBE9YV4lAd4qE3X1O9NQHWnelhNrnTNQXsRoXLXj9euz9St7fbg8+4lxekpnPGAPDt676TMnvDIHnn0RjuBk+zH97LcRuR/i1pstgiPnCh8TBivLz1/dzGdBZ8dvJ+pBrUuHcPopmclN5BKqjAOW1llqGRFta/JP8br8hq4YmgC37bx/C6T6Z7rawTy8FROaGoIHo4xQuT6zNqDW8HGLPRy70BVP7VJC3iJtpNwjCBnYzUSmjoMPY8vRctSUEIHWwzodwIDAQAB", "coords"=>{"transaction-id"=>"e774950c5da53e9ff182523fb6c63591ff5108e4cda6e011870e6fc4863f212a",
              "index"=>1}}]
            },
      })
    # end
  end

  it "unsigned can be signed" do
    VCR.use_cassette ('transactions/signed') do
      key      = ENV["PRIVATE_KEY"].dup
      db_key   = Wallet.db_private_key(key)
      wallet_a = create(:wallet, private_key: db_key)
      wallet_b = create(:wallet)
      user_a   = wallet_a.user


      from_addy = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApoZWMmLesLbU/mTuknlfJx5n9zk1nUmLjvdgxw4iBB0qlcA0ShENeV1UFb6Jcke2OTZ60FgVE+ku8LE0MTBE9YV4lAd4qE3X1O9NQHWnelhNrnTNQXsRoXLXj9euz9St7fbg8+4lxekpnPGAPDt676TMnvDIHnn0RjuBk+zH97LcRuR/i1pstgiPnCh8TBivLz1/dzGdBZ8dvJ+pBrUuHcPopmclN5BKqjAOW1llqGRFta/JP8br8hq4YmgC37bx/C6T6Z7rawTy8FROaGoIHo4xQuT6zNqDW8HGLPRy70BVP7VJC3iJtpNwjCBnYzUSmjoMPY8vRctSUEIHWwzodwIDAQAB"
      to_addy   = wallet_b.address
      amount    = 2
      fee       = 0

      post = ClarkeService.new.parsed_unsigned_payment(from_addy, to_addy, amount, fee)

      sig = ClarkeService.new(user_a).parsed_signed_payment(post)
        expect(sig).to eq({
          "message" => "unsigned_transaction",
            "payload" =>
              {"hash"=>"e774950c5da53e9ff182523fb6c63591ff5108e4cda6e011870e6fc4863f212a",
              "min-height"=>311, "timestamp"=>1465437474376,
              "inputs"=>
                [{"source-hash"=>"2147c1b38df92f5b7a330522bdf837353b799893f8ff4c9d2b2edc521759234c",
                "source-index"=>0}],
              "outputs"=>[{"amount"=>2,
                "address"=>"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqanzFaw1wztAtlzzY3DnBDgV1bWQgXICO12G1/AOQ7t6DVtdqf6fEtNWU1Eg1Fz88HZpWDReAfVTjPERjw5oKEthftLQBbk5AiO3CE3GsGntMyxRBlCPRO1nJms5aqXIao0Vyxsi4TtZggeX84iUOWmz/GQhfCFsMGlOZuGa5Ba7bFTyjC+qH8VsiUr4OqPq09dUl5bohkFbwilv0LoxmIC0yT1bEvEnIXGip66SBjwfMasUrdZRTvAfxVYQGJyOmqtpHiQh5xQASDT8bMDdlZFC0M+/9TXe3PjZoBHdysMTXenjpvBjAmCnp1jkFbmkDsL+3gE2uCYL54hGrpLbIQIDAQAB",
                "coords"=>{"transaction-id"=>"e774950c5da53e9ff182523fb6c63591ff5108e4cda6e011870e6fc4863f212a", "index"=>0}}, {"amount"=>23, "address"=>"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApoZWMmLesLbU/mTuknlfJx5n9zk1nUmLjvdgxw4iBB0qlcA0ShENeV1UFb6Jcke2OTZ60FgVE+ku8LE0MTBE9YV4lAd4qE3X1O9NQHWnelhNrnTNQXsRoXLXj9euz9St7fbg8+4lxekpnPGAPDt676TMnvDIHnn0RjuBk+zH97LcRuR/i1pstgiPnCh8TBivLz1/dzGdBZ8dvJ+pBrUuHcPopmclN5BKqjAOW1llqGRFta/JP8br8hq4YmgC37bx/C6T6Z7rawTy8FROaGoIHo4xQuT6zNqDW8HGLPRy70BVP7VJC3iJtpNwjCBnYzUSmjoMPY8vRctSUEIHWwzodwIDAQAB", "coords"=>{"transaction-id"=>"e774950c5da53e9ff182523fb6c63591ff5108e4cda6e011870e6fc4863f212a",
                "index"=>1}}]
              },
        })
    end
  end
end
