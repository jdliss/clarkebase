require 'rails_helper'

RSpec.feature "User can see all their wallets from dasbhoard" do
  xscenario "a user can see their wallets in the dashboard side-menu" do
    VCR.use_cassette("wallet/dashboard_wallets", record: :new_episodes) do
      user = create(:user)
      login_as user, scope: :user

      visit dashboard_path

      expect(user.primary_wallet).to eq(nil)

      within(".primary-wallet") do
        expect(page).to have_content "Create a Wallet in order to get started!"
      end

      within(".sidebar") do
        expect(page).to_not have_content("Wallet 1")
        expect(page).to_not have_content("0 CLC")
      end

      within(".page-header") do
        click_button "Create New Wallet"
      end

      within("#wallet-form") do
        fill_in :wallet_name, with: "Wallet 1"
        fill_in :private_key, with: ENV["PRIVATE_KEY"]
        click_button "Create"
      end

      within(".modal-footer") do
        click_button "Close"
      end

      within(".sidebar") do
        click_link('.nav-link collapsed')
        expect(page).to have_content("Wallet 1")
        expect(page).to have_content("pending")
        expect(page).to_not have_content("Wallet 2")
      end

      within(".page-header") do
        click_button "Create New Wallet"
        fill_in "WALLET NAME", with: "Wallet 2"
        click_button "Generate a New Wallet"
      end

      wait_for_ajax

      expect(current_path).to eq dashboard_path

      find('.fa-folder-open').trigger('click')

      within(".wallets") do
        expect(page).to have_content("Wallet 1")
        expect(page).to have_content("Wallet 2")
        expect(page).to have_content("0 CLC")
      end
    end
  end
end
