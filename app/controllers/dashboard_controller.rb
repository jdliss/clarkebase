class DashboardController < ApplicationController
  before_action :wallets

  def show
    @sent_transactions = Wallet.all_sent_transactions(@wallets)
    @received_transactions = Wallet.all_received_transactions(@wallets)

  end

end
