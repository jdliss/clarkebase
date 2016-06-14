require 'rails_helper'

RSpec.feature "User can see their public key on wallet page" do
  scenario "a registered user with a wallet can see their address / public_key", js: true do
    VCR.use_cassette('public_key/dashboard', record: :new_episodes) do
      wallet = create(:wallet)
      user   = wallet.user

      login_as user, scope: :user

      visit whallet_dashboard_path(wallet.slug)


      click_on "Your Address"


      within(".inputs") do
        expect(find('#addy').value).to eq "#{wallet.address}"
      end
    end
  end
end
