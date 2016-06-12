require 'rails_helper'

RSpec.feature "User can add friends" do
  xscenario "by email address", js: true do
    VCR.use_cassette("friends/add", record: :new_episodes) do
      user = create(:user)
      user2 = create(:user)
      login_as user, scope: :user

      visit friends_path

      within("#add-friend") do
        fill_in "Email", with: user2.email
        click_button "Add Friend"
      end

      wait_for_ajax

      visit friends_path

      within(".scrollable") do
        expect(page).to have_content(user2.email)
        expect(page).to have_link("Address")
      end
    end
  end

  xscenario "by public key", js: true do
    VCR.use_cassette("friends/add", record: :new_episodes) do
      user = create(:user)
      user2 = create(:user)
      wallet = create(:wallet, user_id: user2.id)
      login_as user, scope: :user

      visit friends_path

      within("#add-friend") do
        fill_in "key", with: user2.wallet.address
        click_button "Add Friend"
      end

      wait_for_ajax

      visit friends_path

      within(".scrollable") do
        expect(page).to have_content(user2.email)
        expect(page).to have_link("Address")
      end
    end
  end
end
