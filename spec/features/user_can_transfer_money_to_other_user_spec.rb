require 'rails_helper'

feature "user can transfer coins to other use" do
  xscenario "user can pay other user in coins if he has a + balance" do
    wallet_a, wallet_b = create_list(:wallet, 2)

    user_a = wallet_a.user
    user_b = wallet_b.user

    login_as user_a

    visit dashboard_path

    click_on "Make a Transfer"

    expect(current_path).to eq new_transfer_path

    VCR.use_cassette("features/make_payment") do
      expect(page).to have_content "Make a Payment"

      fill_in "Receipient Email", with: user_b.email
      fill_in "Amount", with: 2

      click_on "Make Transfer"
    end
    expect(page).to have_content "Successfully Made Payment"
  end


  xscenario "user can't pay other user in coins if he has a 0 balance" do
    wallet_a, wallet_b = create_list(:wallet, 2)

    user_a = wallet_a.user
    user_b = wallet_b.user

    login_as user_b

    visit dashboard_path

    click_on "Make a Transfer"

    expect(current_path).to eq new_transfer_path

    VCR.use_cassette("features/make_payment") do
      expect(page).to have_content "Make a Payment"

      fill_in "Receipient Email", with: user_b.email
      fill_in "Amount", with: 2

      click_on "Make Transfer"
    end
    expect(page).to have_content "You don't have enough coins!"
  end
end
