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

      within(".sidebar") do
        expect(page).to_not have_content("Default")
        expect(page).to_not have_content("0 CLC")
      end

      within(".page-header") do
        click_button "Create New Wallet"
        fill_in "private_key", with: ENV["PRIVATE_KEY"]
        click_button "Import Private Key"
      end

      wait_for_ajax

      expect(current_path).to eq dashboard_path

      find('.fa-folder-open').trigger('click')

      within(".nav-item") do
        expect(page).to have_content("Default")
        expect(page).to_not have_content("Wallet 2")
        expect(page).to have_content("0 CLC")
      end

      within(".page-header") do
        click_button "Create New Wallet"
        click_button "Generate a New Wallet"
      end

      wait_for_ajax

      expect(current_path).to eq dashboard_path

      find('.fa-folder-open').trigger('click')

      within(".wallets") do
        expect(page).to have_content("Default")
        # expect(page).to have_content("Default 2")
        expect(page).to have_content("0 CLC")
      end
    end
  end
end
