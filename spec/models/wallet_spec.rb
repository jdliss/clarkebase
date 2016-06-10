require 'rails_helper'

RSpec.describe Wallet, type: :model do
  it { should belong_to :user }

  it "can store the private key in the database without corrupting it" do
    private_key = Base64.encode64(OpenSSL::PKey::RSA.generate(2048).to_der)
    wallet      = create(:wallet, private_key: private_key)

    expect(wallet.private_key).to eq(private_key.delete("\n"))
  end

  it "can decrypt with the private key after storing it" do
    original_keypair = OpenSSL::PKey::RSA.generate(2048)
    private_key      = Base64.encode64(original_keypair.to_der).delete("\n")
    wallet           = create(:wallet, private_key: private_key)
    test_string      = "this is a test"

    formatted_key = KeyCleanerService.private_strict_format(wallet.private_key)
    db_keypair    = OpenSSL::PKey::RSA.new(formatted_key)
    encrypted     = original_keypair.private_encrypt(test_string)
    decrypted     = db_keypair.public_decrypt(encrypted)

    expect(decrypted).to eq(test_string)
  end
end
