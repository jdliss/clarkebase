require 'rails_helper'

RSpec.describe Wallet, type: :model do
  it { should belong_to :user }
  it { is_expected.to callback(:generate_private_key).before(:save) }

  it "can store the private key in the database without corrupting it" do
    private_key = OpenSSL::PKey::RSA.generate(2048)
    wallet      = create(:wallet, private_key: private_key)

    expect(wallet.private_key).to eq(private_key)
  end

  it "can decrypt with the private key after storing it" do
    original_key  = OpenSSL::PKey::RSA.generate(2048)
    wallet        = create(:wallet, private_key: original_key)
    db_public_key = wallet.private_key.public_key
    test_string   = "this is a test"

    encrypted = original_key.private_encrypt(test_string)
    decrypted = db_public_key.public_decrypt(encrypted)

    expect(decrypted).to eq(test_string)
  end
end
