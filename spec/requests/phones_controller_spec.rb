require 'rails_helper'

RSpec.describe Api::V1::PhonesController do
  it "should update the user's phone number" do
    user = create(:user)
    login_as user

    expect(user.phone).to eq ""

    patch api_v1_phones_path, format: :json, phone_number: "1234567890"

    expect(user.phone).to eq "1234567890"
  end
end
