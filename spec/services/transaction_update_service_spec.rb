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
        :from => "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAs9Fwo/n22MKL8BwZ7zRdKeorCMi2m0iwYp21ZL9aL8lAO62KH8n6vB7AEWAEYxTJ1frG2vJ5zk67yTeIE80GVH3Fs1Y2zlreUMDa0c/AkIO2DpMHSwGAz2DZHJ6vHptE/gChgjhkyZnlaQ2AQRC3RfDj495ViezusHkeWAdWktC66rWzR48B7224VV5OaFWqL9S+vcOY46kJIgFhQtnSg4v1zQfltecNkBlsHLfrklm1Vv4yYI9fsEyMTVWkpjNZ7Q62bxw/6JdvcYb4v0tjmBJMaaZcEH4EYx2bKZCxlssSqlkvn7tVVXNov5uT6NShkX7TjbKK3fbs4SsNBGAB/QIDAQAB",
        :to   => "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApoZWMmLesLbU/mTuknlfJx5n9zk1nUmLjvdgxw4iBB0qlcA0ShENeV1UFb6Jcke2OTZ60FgVE+ku8LE0MTBE9YV4lAd4qE3X1O9NQHWnelhNrnTNQXsRoXLXj9euz9St7fbg8+4lxekpnPGAPDt676TMnvDIHnn0RjuBk+zH97LcRuR/i1pstgiPnCh8TBivLz1/dzGdBZ8dvJ+pBrUuHcPopmclN5BKqjAOW1llqGRFta/JP8br8hq4YmgC37bx/C6T6Z7rawTy8FROaGoIHo4xQuT6zNqDW8HGLPRy70BVP7VJC3iJtpNwjCBnYzUSmjoMPY8vRctSUEIHWwzodwIDAQAB"
      }]

      expect(results).to eq expected
    end
  end
end
