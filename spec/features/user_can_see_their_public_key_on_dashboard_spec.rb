require 'rails_helper'

RSpec.feature "User can see their public key on dashboard" do
  scenario "a registered user with a wallet can see their address / public_key", js: true do
    VCR.use_cassette('public_key/dashboard') do
      wallet = create(:wallet)
      user   = wallet.user

      login_as user, scope: :user

      visit dashboard_path

      within(".user-keys") do
        expect(page).to have_content "Address: #{wallet.address}"
      end
    end
  end
end
