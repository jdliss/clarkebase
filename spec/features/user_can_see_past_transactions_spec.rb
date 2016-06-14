require 'rails_helper'

RSpec.feature "User can see past sent transactions" do
  scenario "they can see past transactions on their dash" do
    VCR.use_cassette("features/past_transactions") do
      key           = ENV["PRIVATE_KEY"].dup
      pub           = ENV["PUBLIC_KEY"].dup
      wallet_a      = create(:wallet, private_key: key, public_key: pub)
      user_a        = wallet_a.user
      wallet_b      = create(:wallet)
      user_b        = wallet_b.user
      from_addy     = wallet_a.address
      to_addy       = wallet_b.address
      amount        = 2
      allow_any_instance_of(ClarkeService).to receive(:get_node).and_return("http://159.203.206.61:3000")
      transaction   = Transaction.create(amount: amount, from: from_addy, to: to_addy)

      login_as user_a


      visit whallet_dashboard_path(wallet_a)

      expect(page).to have_content "Sent Transactions"

      within(".sent-transactions") do
        expect(page).to have_content user_b.email
        expect(page).to have_content transaction.amount
        expect(page).to have_content transaction.status
        expect(page).to have_content transaction.time
      end

      login_as user_b


      visit whallet_dashboard_path(wallet_b)

      expect(page).to have_content "Received Transactions"

      within(".received-transactions") do
        expect(page).to have_content user_a.email
        expect(page).to have_content transaction.amount
        expect(page).to have_content transaction.status
        expect(page).to have_content transaction.time
      end
    end
  end
end
