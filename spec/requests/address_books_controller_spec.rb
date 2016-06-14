require 'rails_helper'

RSpec.describe Api::V1::AddressBooksController do
  it "creates a friendship when given an email" do
    user, user2 = create_list(:user, 2)
    login_as user

    expect(user.friends).to_not include(user2)

    patch api_v1_address_books_path, format: :json, email: user2.email

    expect(user.friends).to include(user2)
  end

end
