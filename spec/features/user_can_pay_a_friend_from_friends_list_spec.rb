require 'rails_helper'

feature "user can pay a friend from friends list" do
  xscenario "sucessfully", js: true do
    VCR.use_cassette("features/pay_friend", record: :new_episodes) do
      wallet_a, wallet_b = create_list(:wallet, 2)

      key           = ENV["PRIVATE_KEY"].dup
      pub           = ENV["PUBLIC_KEY"].dup
      wallet_a      = create(:wallet, private_key: key, public_key: pub)
      wallet_b      = create(:wallet)
      user_a        = wallet_a.user
      user_b        = wallet_b.user
      user_a.friends += [user_b]

      login_as user_a
      visit friends_path

      within(".scrollable") do
        expect(page).to have_content user_b.email
      end

      click_on "Pay"
      fill_in "AMOUNT", with: 5
      click_on "Send"

      sleep(3)

      to = get_pending_transactions.first["address"]
      from =  get_pending_transactions.last["address"]

      expect(to).to eq wallet_b.address
      expect(from).to eq wallet_a.address
    end
  end
end
