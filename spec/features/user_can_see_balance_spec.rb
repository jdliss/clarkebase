require 'rails_helper'

RSpec.feature "User can see their balance" do
  scenario "a registered user with a wallet can see their balance", js: true do
    VCR.use_cassette("balance") do
      wallet = create(:wallet)
      user   = wallet.user
      allow_any_instance_of(ClarkeService).to receive(:get_node).and_return("http://159.203.206.61:3000")

      login_as user, scope: :user

      visit whallet_dashboard_path(wallet)


      expect(page).to have_content "93"

    end
  end
end
