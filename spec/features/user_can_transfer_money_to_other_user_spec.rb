require 'rails_helper'

feature "user can transfer coins to other use" do
  scenario "user can pay other user in coins if he has a + balance", js: true do
    VCR.use_cassette("features/make_payment", record: :new_episodes) do
      wallet_a, wallet_b = create_list(:wallet, 2)


      key           = ENV["PRIVATE_KEY"].dup
      pub           = ENV["PUBLIC_KEY"].dup
      wallet_a      = create(:wallet, private_key: key, public_key: pub)
      wallet_b      = create(:wallet)
      user_a        = wallet_a.user
      user_b        = wallet_b.user


      login_as user_a

      visit transactions_new_path

      expect(page).to have_content "Send Coins"

      fill_in "RECEIPIENT EMAIL", with: user_b.email
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
