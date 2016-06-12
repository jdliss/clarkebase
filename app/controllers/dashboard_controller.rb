class DashboardController < ApplicationController
  before_action :wallets

  def show
    if current_user.primary_wallet
      @sent_transactions = current_user.primary_wallet.sent_transactions
      @received_transactions = current_user.primary_wallet.received_transactions
    end
  end
end
