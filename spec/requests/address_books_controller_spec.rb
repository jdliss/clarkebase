require 'rails_helper'

RSpec.describe Api::V1::AddressBooksController do
  it "creates a friendship when given an email" do
    user, user2 = create_list(:user, 2)
    login_as user

    expect(user.friends).to_not include(user2)

    patch api_v1_address_books_path, format: :json, email: user2.email

    expect(user.friends).to include(user2)
  end

  it "adds creates a friendship when given a public key" do
    user, user2 = create_list(:user, 2)
    wallet = create(:wallet, user_id: user2.id)
    wallet.primary!
    login_as user

    expect(user.friends).to_not include(user2)

    patch api_v1_address_books_path, format: :json, key: user2.primary_wallet.address

    expect(user.friends).to include(user2)
  end
end
