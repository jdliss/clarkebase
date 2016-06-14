require "rails_helper"

RSpec.feature "User can See the info on the dashboard page" do
  scenario "user can see all pending/received transactions and total balance from all wallets" do
    VCR.use_cassette("features/dashboard_info", record: :new_episodes) do
      key           = ENV["PRIVATE_KEY"].dup
      pub           = ENV["PUBLIC_KEY"].dup
      wallet_a      = create(:wallet, private_key: key, public_key: pub)
      user_a        = wallet_a.user
      wallet_b      = create(:wallet)
      user_b        = wallet_b.user
      from_addy     = wallet_a.address
      to_addy       = wallet_b.address
      amount        = 2
      transaction   = Transaction.create(amount: amount, from: from_addy, to: to_addy)
      transaction2   = Transaction.create(amount: 10, from: from_addy, to: to_addy)

      allow_any_instance_of(ClarkeService).to receive(:get_node).and_return("http://159.203.206.61:3000")

      login_as user_a

      visit dashboard_path

      expect(page).to have_content "Total Balance: 2471"


      expect(page).to have_content user_b.email
      expect(page).to have_content transaction.amount
      expect(page).to have_content transaction.status
      expect(page).to have_content transaction.time
      expect(page).to have_content transaction2.amount
      expect(page).to have_content transaction2.status
      expect(page).to have_content transaction2.time


      login_as user_b

      visit dashboard_path

      expect(page).to have_content "Total Balance: "

      expect(page).to have_content "Received Transactions"


      expect(page).to have_content user_a.email
      expect(page).to have_content transaction.amount
      expect(page).to have_content transaction.status
      expect(page).to have_content transaction.time
      expect(page).to have_content transaction2.amount
      expect(page).to have_content transaction2.status
      expect(page).to have_content transaction2.time


    end
  end
end
