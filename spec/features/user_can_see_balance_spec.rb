require 'rails_helper'

RSpec.feature "User can see their balance" do
  scenario "a registered user with a wallet can see their balance", js: true do
    wallet = create(:wallet)
    user   = wallet.user

    login_as user, scope: :user

    visit dashboard_path

    within(".user-keys") do
      expect(page).to have_content "Balance: #{wallet.balance}"
    end
    save_and_open_page
  end
end
