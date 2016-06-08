require 'rails_helper'

RSpec.feature "User can create a wallet" do
  xscenario "a registered user with no wallet is offered to create a wallet", js: true do
    user = create(:user)
    login_as user, scope: :user

    visit dashboard_path

    expect(user.wallet).to eq(nil)

    within(".welcome-message") do
      expect(page).to have_content "Get started by creating your first wallet"
      click_button "Create Wallet"
    end

    wait_for_ajax

    within(".flash") do
      expect(page).to have_content "Your Wallet has been created!"
    end

    expect(user.wallet).to exist
  end
end
