require 'rails_helper'

RSpec.describe Wallet, type: :model do
  it { should belong_to :user }
  # it { is_expected.to callback(:generate_private_key).before(:save) }

  it "can store the private key in the database without corrupting it" do
    private_key = OpenSSL::PKey::RSA.generate(2048)
    wallet      = create(:wallet, private_key: private_key.to_pem)

    expect(wallet.private_key).to eq(private_key)
  end

  xit "can decrypt with the private key after storing it" do
    original_keypair = OpenSSL::PKey::RSA.generate(2048)
    wallet           = create(:wallet, private_key: original_keypair.to_pem)
    db_public_key    = wallet.public_key
    test_string      = "this is a test"


    db_keypair = OpenSSL::PKey::RSA.new(wallet.public_key)
    encrypted  = original_keypair.private_encrypt(test_string)

    require "pry"
    binding.pry

    decrypted = db_keypair.public_decrypt(encrypted)

    expect(decrypted).to eq(test_string)
  end
end
