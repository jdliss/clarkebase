require 'rails_helper'

RSpec.describe Transaction, type: :model do

  it 'can update_transactions when pending_transactions is empty' do
    VCR.use_cassette("models/update_transaction") do
      key           = ENV["PRIVATE_KEY"].dup
      pub           = ENV["PUBLIC_KEY"].dup
      wallet_a      = create(:wallet, private_key: key, public_key: pub)
      key_b           = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAs9Fwo/n22MKL8BwZ7zRdKeorCMi2m0iwYp21ZL9aL8lAO62KH8n6vB7AEWAEYxTJ1frG2vJ5zk67yTeIE80GVH3Fs1Y2zlreUMDa0c/AkIO2DpMHSwGAz2DZHJ6vHptE/gChgjhkyZnlaQ2AQRC3RfDj495ViezusHkeWAdWktC66rWzR48B7224VV5OaFWqL9S+vcOY46kJIgFhQtnSg4v1zQfltecNkBlsHLfrklm1Vv4yYI9fsEyMTVWkpjNZ7Q62bxw/6JdvcYb4v0tjmBJMaaZcEH4EYx2bKZCxlssSqlkvn7tVVXNov5uT6NShkX7TjbKK3fbs4SsNBGAB/QIDAQAB"
      wallet_b      = create(:wallet, public_key: key_b)

      allow_any_instance_of(TransactionUpdateService).to receive(:parse_current_pending).and_return([])
      allow_any_instance_of(Transaction).to receive(:send_transaction).and_return(200)

      transaction = Transaction.create(from: ENV["PUBLIC_KEY"], to: key_b,
      amount: 10, status: 0)

      Transaction.update_transactions

      expect(Transaction.first.status).to eq "completed"
    end
  end

  it 'doesnt update_transactions when pending_transactions is has corresponding transaction' do
    VCR.use_cassette("models/update_transaction") do
      key                  = ENV["PRIVATE_KEY"].dup
      pub                  = ENV["PUBLIC_KEY"].dup
      wallet_a             = create(:wallet, private_key: key, public_key: pub)
      pending_transactions = [{from: pub, to: "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAs9Fwo/n22MKL8BwZ7zRdKeorCMi2m0iwYp21ZL9aL8lAO62KH8n6vB7AEWAEYxTJ1frG2vJ5zk67yTeIE80GVH3Fs1Y2zlreUMDa0c/AkIO2DpMHSwGAz2DZHJ6vHptE/gChgjhkyZnlaQ2AQRC3RfDj495ViezusHkeWAdWktC66rWzR48B7224VV5OaFWqL9S+vcOY46kJIgFhQtnSg4v1zQfltecNkBlsHLfrklm1Vv4yYI9fsEyMTVWkpjNZ7Q62bxw/6JdvcYb4v0tjmBJMaaZcEH4EYx2bKZCxlssSqlkvn7tVVXNov5uT6NShkX7TjbKK3fbs4SsNBGAB/QIDAQAB" }]
      allow_any_instance_of(Transaction).to receive(:send_transaction).and_return(200)
      allow_any_instance_of(TransactionUpdateService).to receive(:parse_current_pending).and_return(pending_transactions)

      transaction = Transaction.create(from: ENV["PUBLIC_KEY"], to: "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAs9Fwo/n22MKL8BwZ7zRdKeorCMi2m0iwYp21ZL9aL8lAO62KH8n6vB7AEWAEYxTJ1frG2vJ5zk67yTeIE80GVH3Fs1Y2zlreUMDa0c/AkIO2DpMHSwGAz2DZHJ6vHptE/gChgjhkyZnlaQ2AQRC3RfDj495ViezusHkeWAdWktC66rWzR48B7224VV5OaFWqL9S+vcOY46kJIgFhQtnSg4v1zQfltecNkBlsHLfrklm1Vv4yYI9fsEyMTVWkpjNZ7Q62bxw/6JdvcYb4v0tjmBJMaaZcEH4EYx2bKZCxlssSqlkvn7tVVXNov5uT6NShkX7TjbKK3fbs4SsNBGAB/QIDAQAB",
                                      amount: 5, status: 0)

      Transaction.update_transactions

      expect(Transaction.first.status).to eq "pending"
    end
  end


end
