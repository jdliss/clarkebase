require 'rails_helper'

RSpec.feature "User can see all their wallets from dasbhoard" do
  scenario "a user can see their wallets in the dashboard side-menu", js: true do
    VCR.use_cassette("wallet/dashboard_wallets", record: :new_episodes) do
      user = create(:user)
      login_as user, scope: :user

      visit '/dashboard'

      expect(user.primary_wallet).to eq(nil)

      within(".primary-wallet") do
        expect(page).to have_content "Create a Wallet in order to get started!"
      end

      within(".page-header") do
        click_button "Create New Wallet"
        fill_in "private_key", with: ENV["PRIVATE_KEY"]
        click_button "Import Private Key"
      end

      wait_for_ajax

      expect(current_path).to eq dashboard_path

      within(".sidebar") do
        click_link "Wallets"
      end

      within(".wallets") do
        expect(page).to have_content("Wallet 1")
        expect(page).to have_content("0 CLC")
      end
    end
  end
end
