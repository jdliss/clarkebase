require 'rails_helper'

describe "PATCH /api/v1/address_books/" do
  xit "adds a user to another's friend's list by email" do

    user1, user2 = create_list(:user, 2)
    login_as user1

    patch "/api/v1/address_books?email=#{user2.email}"

    expect(response.body).to eq "{\"message\":\"success\"}"
    expect(User.find(user1.id).friends.first).to eq user2
  end

  xit "adds a user to another's friend's list by public key" do

    wallet = create(:wallet)
    user2  = wallet.user
    user1 = create(:user)
    login_as user1

    patch "/api/v1/address_books?key=#{wallet.address}"

    expect(response.body).to eq "{\"message\":\"success\"}"
    expect(User.find(user1.id).friends.first).to eq user2
  end
end
