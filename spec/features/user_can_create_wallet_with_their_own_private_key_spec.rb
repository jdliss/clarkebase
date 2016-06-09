require 'rails_helper'

RSpec.feature "User can create a wallet" do
  xscenario "a registered user with no wallet is offered to create a wallet", js: true do
    user = create(:user)

    login_as user, scope: :user
    visit wallets_new_path

    expect(user.wallet).to eq(nil)

    within(".new-wallet-message") do
      expect(page).to have_content "You Need a Wallet"
      fill_in "Private Key:", with: ENV["PRIVATE_KEY"]
      click_button "Create Wallet"
    end

    wait_for_ajax

    click_button "Take Me to My Dashboard"

    expect(current_page).to eq dashboard_path
    expect(user.wallet).to exist
    expect(Base64.strict_encode64(user.wallet.private_key)).to eq EVN["PRIVATE_KEY"]
  end
end
