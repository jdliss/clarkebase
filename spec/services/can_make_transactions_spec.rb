require 'rails_helper'
require 'keycleaner_service'


describe "can get unsigned
  payment transactions" do
  it "can get unsigned" do
    VCR.use_cassette("transactions/unsigned") do

      key           = ENV["PRIVATE_KEY"].dup
      pub           = ENV["PUBLIC_KEY"].dup
      wallet_a      = create(:wallet, private_key: key, public_key: pub)
      wallet_b      = create(:wallet)

      from_addy = wallet_a.address
      to_addy   = wallet_b.address

      amount    = 2
      fee       = 0

      allow_any_instance_of(ClarkeService).to receive(:get_node).and_return("http://159.203.206.61:3000")

      post = ClarkeService.new.parsed_unsigned_payment(from_addy, to_addy, amount, fee)


      expect(post).to eq(
        {"message"=>"unsigned_transaction", "payload"=>{"hash"=>"c9a21cce774f3e115bfa76ea4955593bf0ad74efed4b4f27b9e39fdadf321a5f", "min-height"=>1771, "timestamp"=>1465931307237, "inputs"=>[{"source-hash"=>"9f13c83b39967857d16c6886fbd3d1c905c6e0a815a7821a3fe64b560610ac64", "source-index"=>0}], "outputs"=>[{"amount"=>2, "address"=>"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAs9Fwo/n22MKL8BwZ7zRdKeorCMi2m0iwYp21ZL9aL8lAO62KH8n6vB7AEWAEYxTJ1frG2vJ5zk67yTeIE80GVH3Fs1Y2zlreUMDa0c/AkIO2DpMHSwGAz2DZHJ6vHptE/gChgjhkyZnlaQ2AQRC3RfDj495ViezusHkeWAdWktC66rWzR48B7224VV5OaFWqL9S+vcOY46kJIgFhQtnSg4v1zQfltecNkBlsHLfrklm1Vv4yYI9fsEyMTVWkpjNZ7Q62bxw/6JdvcYb4v0tjmBJMaaZcEH4EYx2bKZCxlssSqlkvn7tVVXNov5uT6NShkX7TjbKK3fbs4SsNBGAB/QIDAQAB", "coords"=>{"transaction-id"=>"c9a21cce774f3e115bfa76ea4955593bf0ad74efed4b4f27b9e39fdadf321a5f", "index"=>0}}, {"amount"=>23, "address"=>"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApoZWMmLesLbU/mTuknlfJx5n9zk1nUmLjvdgxw4iBB0qlcA0ShENeV1UFb6Jcke2OTZ60FgVE+ku8LE0MTBE9YV4lAd4qE3X1O9NQHWnelhNrnTNQXsRoXLXj9euz9St7fbg8+4lxekpnPGAPDt676TMnvDIHnn0RjuBk+zH97LcRuR/i1pstgiPnCh8TBivLz1/dzGdBZ8dvJ+pBrUuHcPopmclN5BKqjAOW1llqGRFta/JP8br8hq4YmgC37bx/C6T6Z7rawTy8FROaGoIHo4xQuT6zNqDW8HGLPRy70BVP7VJC3iJtpNwjCBnYzUSmjoMPY8vRctSUEIHWwzodwIDAQAB", "coords"=>{"transaction-id"=>"c9a21cce774f3e115bfa76ea4955593bf0ad74efed4b4f27b9e39fdadf321a5f", "index"=>1}}]}})
    end
  end

  it "unsigned can be signed" do
    VCR.use_cassette("transactions/signed") do
      key           = ENV["PRIVATE_KEY"].dup
      pub           = ENV["PUBLIC_KEY"].dup
      wallet_a      = create(:wallet, private_key: key, public_key: pub)
      wallet_b      = create(:wallet)
      user_a        = wallet_a.user

      from_addy = wallet_b.address
      to_addy   = wallet_a.address
      amount    = 2
      fee       = 0


      allow_any_instance_of(ClarkeService).to receive(:get_node).and_return("http://159.203.206.61:3000")

      post = ClarkeService.new.parsed_unsigned_payment(from_addy, to_addy, amount, fee)

      sig = ClarkeService.new(wallet_b.private_key).parsed_signed_payment(post)


        expect(sig.body).to eq(
          "{\"message\":\"transaction-accepted\",\"payload\":{\"hash\":\"c2b2cad7a6cd705d8210b33b47f8938ff58ca7960405a6edf6f7294421ceb0f1\",\"min-height\":1778,\"timestamp\":1465933834289,\"inputs\":[{\"source-hash\":\"54669a3d4d14337f0fd2523f55de3175b2909d04d0bc549e3f5bd2a6add75989\",\"source-index\":1,\"signature\":\"T9PbCkhN+O+aKZ8dH83XlthdLFV52Aha2AyE1+zDudhlT9AESj+U6+R6MKV5yWEZkSUS8T1Z3cqX117+AWQj6FUopDPDikBqwkaazX+Lut8pbM3zyZrs3M/PSlsqUNc5WMr18gFyCeB0e/66tVy04TPTBc8wCYXNyjaIfk7vy5PwqduU6L/JABi0eEHRBbafI87lk5gNRgc1w/8yxaiuAsxxwgEEEhl/Q9DtQI5P5z+AzZkSrdy5llK6f5MWsSrdYrV3CwWRSWnAuHi4brQVjrlf9lLhkc0EB8cyIptAjJqTbb8IxTCYn6ymB5xKCRsiShqJ/uLmixOorHVptuGPFQ==\"}],\"outputs\":[{\"amount\":2,\"address\":\"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApoZWMmLesLbU/mTuknlfJx5n9zk1nUmLjvdgxw4iBB0qlcA0ShENeV1UFb6Jcke2OTZ60FgVE+ku8LE0MTBE9YV4lAd4qE3X1O9NQHWnelhNrnTNQXsRoXLXj9euz9St7fbg8+4lxekpnPGAPDt676TMnvDIHnn0RjuBk+zH97LcRuR/i1pstgiPnCh8TBivLz1/dzGdBZ8dvJ+pBrUuHcPopmclN5BKqjAOW1llqGRFta/JP8br8hq4YmgC37bx/C6T6Z7rawTy8FROaGoIHo4xQuT6zNqDW8HGLPRy70BVP7VJC3iJtpNwjCBnYzUSmjoMPY8vRctSUEIHWwzodwIDAQAB\",\"coords\":{\"transaction-id\":\"c2b2cad7a6cd705d8210b33b47f8938ff58ca7960405a6edf6f7294421ceb0f1\",\"index\":0}},{\"amount\":1,\"address\":\"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAs9Fwo/n22MKL8BwZ7zRdKeorCMi2m0iwYp21ZL9aL8lAO62KH8n6vB7AEWAEYxTJ1frG2vJ5zk67yTeIE80GVH3Fs1Y2zlreUMDa0c/AkIO2DpMHSwGAz2DZHJ6vHptE/gChgjhkyZnlaQ2AQRC3RfDj495ViezusHkeWAdWktC66rWzR48B7224VV5OaFWqL9S+vcOY46kJIgFhQtnSg4v1zQfltecNkBlsHLfrklm1Vv4yYI9fsEyMTVWkpjNZ7Q62bxw/6JdvcYb4v0tjmBJMaaZcEH4EYx2bKZCxlssSqlkvn7tVVXNov5uT6NShkX7TjbKK3fbs4SsNBGAB/QIDAQAB\",\"coords\":{\"transaction-id\":\"c2b2cad7a6cd705d8210b33b47f8938ff58ca7960405a6edf6f7294421ceb0f1\",\"index\":1}}]}}")
    end
  end
end
