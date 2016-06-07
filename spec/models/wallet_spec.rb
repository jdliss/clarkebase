require 'rails_helper'

RSpec.describe Wallet, type: :model do
  it { should belong_to :user }

  it "can generate a new private key" do
    wallet      = Wallet.new
    private_key = wallet.private_key

    expect(private_key.class).to eq String
  end
end
